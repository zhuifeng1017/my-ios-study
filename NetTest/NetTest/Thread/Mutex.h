#ifndef MUTEXT_H_
#define MUTEXT_H_

 namespace Threads
{
    class Mutex
    {
public:
        Mutex();
        ~Mutex();

        void Lock();
        void Unlock();

protected:
        void*   m;
    };

    class Guard
    {
 public:
        Guard( Mutex* m );
        ~Guard();
 
protected:
           Mutex* m_mutex;
    };              
}



#endif /*MUTEXT_H_*/
