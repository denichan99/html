#!/bin/bash

# Функция для генерации случайного числа от 1 до 100
generate_random_number() {
    echo $((1 + RANDOM % 100))
}

# Генерируем случайное число и сохраняем его в переменной
secret_number=$(generate_random_number)

# Создаем HTML-файл
cat <<EOL >index.html
<!DOCTYPE html>
<html>
<head>
    <title>Угадай число</title>
</head>
<body>

<h1>Игра "Угадай число от 1 до 100"</h1>
<p>Попробуйте угадать число от 1 до 100:</p>

<form action="" method="post">
    <label for="guess">Ваш вариант:</label>
    <input type="text" id="guess" name="guess" required>
    <input type="submit" value="Проверить">
</form>

EOL

# Проверяем, была ли отправлена форма
if [ "$REQUEST_METHOD" == "POST" ]; then
    # Получаем введенное пользователем число
    user_guess=${QUERY_STRING#*guess=}

    # Проверяем, является ли введенное значение числом
    if [[ $user_guess =~ ^[0-9]+$ ]]; then
        # Сравниваем введенное число с загаданным
        if [ $user_guess -eq $secret_number ]; then
            echo "<p>Поздравляем! Вы угадали число $secret_number!</p>" >>index.html
        elif [ $user_guess -lt $secret_number ]; then
            echo "<p>Попробуйте еще раз. Ваше число меньше загаданного.</p>" >>index.html
        else
            echo "<p>Попробуйте еще раз. Ваше число больше загаданного.</p>" >>index.html
        fi
    else
        echo "<p>Пожалуйста, введите корректное число.</p>" >>index.html
    fi
fi

# Завершаем HTML-файл
echo "</body></html>" >>index.html

# Выводим сообщение об успешном создании файла
echo "HTML-страница для игры 'Угадай число' создана в файле index.html"

