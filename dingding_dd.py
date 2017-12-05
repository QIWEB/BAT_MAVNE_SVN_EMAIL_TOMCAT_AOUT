import requests
import json
import urllib.parse
url = 'https://oapi.dingtalk.com/robot/send?access_token=1674aad6ab2bbaedfdf1d09b0bf4e6a5fe013411ac16a8af96fd2aa3158f3720'
HEADERS = {
"Content-Type": "application/json ;charset=utf-8 "
}
f = open("C:\\Users\\zhangqi\\Desktop\\auto\\data.txt","r",encoding='utf-8')  
lines = f.readlines()#读取全部内容  
f.close()
String_textMsg = {\
"msgtype": "text",\
"text": {"content": '%s'%(lines)}}
String_textMsg = json.dumps(String_textMsg)
res = requests.post(url, data=String_textMsg, headers=HEADERS)
print(res.text)
