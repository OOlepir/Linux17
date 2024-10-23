#!/bin/bash

read -p "Введите IP или домен для пинга: " target

fail_count=0

while true; do
    ping_result=$(ping -c 1 -W 1 $target | grep 'time=')

    if [[ -n $ping_result ]]; then
        ping_time=$(echo $ping_result | sed -n 's/.*time=\([0-9.]*\) ms.*/\1/p')

        if (( $(echo "$ping_time > 100" | bc -l) )); then
            echo "Время пинга превиает 100 мс: $ping_time мс."
        else
            echo "Пинг успешен: $ping_time мс."
        fi

        fail_count=0
    else
        fail_count=$((fail_count + 1))
        echo "Ошибка пинга! Неуспешние попитки: $fail_count."

        if [[ $fail_count -ge 3 ]]; then
            echo "Пинг не удалса 3 раза подряд! Проверте соединение."
            fail_count=0
        fi
    fi

    sleep 1
done
