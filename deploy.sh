#!/bin/bash
#Параметры deploy
deployHost=192.168.58.203
deployLogin=factoryfactory
deployPassword=samara2015
deployPath=/home/factoryfactory/apps/factory
#<!-- отрезаем последний каталог-->
S=$PWD
P=0
P=$(expr index "$S" "/")
while [[ $P > 0 ]]; do
  S=${S:P}
  P=$(expr index "$S" "/")
done
newPath=${deployPath:0:${#deployPath}-${#S}}
echo $newPath
#</!-- отрезаем последний каталог-->
#Отмечаем время начала выполнения скрипта
START=$(date +%s)
count=$(ping -c 1 $deployHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
if [ $count -eq 1 ]
then #Можно деплоить хост доступен
                echo -e "Host '$deployHost' available."
                #Получаем id удаленного процесса ruby
                pid=$(sshpass -p $deployPassword ssh $deployLogin@$deployHost 'pgrep ruby')
                if [[ "1$pid 1" != "1 1" ]]; then
                    echo -e "Удалемый процесс обнаружен id=$pid"
                    sshpass -p $deployPassword ssh $deployLogin@$deployHost "kill -9 $pid"
                else 
                    echo -e "rails на целевом сервере не запущен...\n"    
                fi
                #Копируем файлы из текущего каталога в целевой каталог на основном сервере
                #Предварительно удалим мусор
                if [ -d "tmp" ]; then
            	    rm -rf tmp
                fi    
                if [ -d 'log' ]; then
                    rm -rf log
                fi    
                if [ -f 'Gemfile.lock' ]; then
            	    rm -rf Gemfile.lock
                fi
                #Переносим файлы из текущего каталога в каталог на удаленном сервере в соответствии со значением переменных
                #Немного операций со строками
                sshpass -p $deployPassword scp -rv $PWD $deployLogin@$deployHost:$newPath
                #Ну и запускаем удаленный процесс
                echo "Запускаем удаленно сервер по удаленному адресу: $deployPath"
                sshpass -p $deployPassword ssh $deployLogin@$deployHost << !
            	    cd $deployPath
            	    rm -rf Gemfile.lock
            	    #bundle install
            	    rake db:migrate
            	    rails s -b 0.0.0.0 -d 
!
else #деплоить не получится, хост не доступен
                echo -e "Host '$deployHost' unreachable.\nCan't deploy!"
fi

#Считаем сколько выполнялся скрипт
END=$(date +%s)
DIFF=$((END-START))
M=$(($DIFF / 60))
S=$(($DIFF % 60))
echo "Выполнено за $M минут, $S секунд"