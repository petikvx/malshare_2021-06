#!/bin/bash
TOKEN='1322235264:AAE7QI-f1GtAF_huVz8E5IBdb5JbWIIiGKI'
MSG_URL='https://api.telegram.org/bot'$TOKEN'/sendMessage?chat_id='
ID_MSG='1297663267
1121093080'

send_message ()
{
        res=$(curl -s --insecure --data-urlencode "text=$2" "$MSG_URL$1&" &)
}

who > /tmp/.ccw #сохраняем во временный файл результат
while true; do {
    gg=$(who) #получаем список сессий
    master=$(cat /tmp/.ccw | wc -l) #считаем количество строк у временного файла
    slave=$(echo "${gg}" | wc -l) #считаем количество строк текущих сессий
    if [[ "$master" != "$slave" ]] #если количество строк не равно, то отправляем сообщение
    then
        for id in $ID_MSG
                do
                        send_message $id "$(hostname) $(hostname -I)
${gg}"
                done
        echo "${gg}" > /tmp/.ccw #сохраняем во временный файл, для последущего сравнения
    fi
    sleep 5
}; done
