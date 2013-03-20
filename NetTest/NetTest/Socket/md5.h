#ifndef MOXU_MD5_H
#define MOXU_MD5_H

namespace moxu
{

// ��������һ���ַ���������md5�㷨����󣬷��ؽ����һ��������32���ַ����ַ��� 
char* Md5String(char* str);

// ��������һ���ļ������ļ����ݾ���md5�㷨����󣬷��ؽ����һ��������32���ַ����ַ���
char* Md5File(char* fname);

// ��������һ���ַ���text,��һ��������Կ���ַ���key������hmac_md5�㷨�������ش�������һ�������ַ�����32���ַ���
char* HmacMd5(char* text, char* key);

} // namespace moxu

#endif // MOXU_MD5_H
