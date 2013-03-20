#include "Mutex.h"
#include <pthread.h>

namespace Threads
{
                Mutex::Mutex()
                {
    
#ifdef _WIN32
                        m = (void*) new CRITICAL_SECTION;
                        InitializeCriticalSection((CRITICAL_SECTION*) m );
#else
                        m = (void*) new pthread_mutex_t;
                        pthread_mutex_init((pthread_mutex_t*)m, NULL);
#endif
                }

                Mutex::~Mutex()
                {
#ifdef _WIN32
                        DeleteCriticalSection((CRITICAL_SECTION*) m );
                        delete ((CRITICAL_SECTION*)m);
#else
                        pthread_mutex_destroy((pthread_mutex_t*)m);
                        delete ((pthread_mutex_t*)m);
#endif
                        m = NULL;
                }

                void Mutex::Lock()
                {
                        #ifdef _WIN32
                                EnterCriticalSection((CRITICAL_SECTION*)m);
                        #else
                                pthread_mutex_lock((pthread_mutex_t*)m);
                        #endif
                }

                void Mutex::Unlock()
                {
                        #ifdef _WIN32
                                LeaveCriticalSection((CRITICAL_SECTION*)m);
                        #else
                                pthread_mutex_unlock((pthread_mutex_t*)m);
                        #endif
                }
    
    
    Guard::Guard( Mutex* m ) : m_mutex(m)
    {
        m_mutex->Lock();
    }
    
    Guard::~Guard()
    {
        m_mutex->Unlock();
    }

 }