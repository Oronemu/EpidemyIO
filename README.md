
<br />
<div align="center">
    <img src="https://sun9-27.userapi.com/impg/dzI_m45o7jZlgTX1ETtA3-YZ9-36XPv_k6kqfQ/Zp9WA2LmxVk.jpg?size=512x535&quality=95&sign=88beb5d3cad46c28a06c522c7e7f432a&type=album" alt="Logo" width="100" height="100">

  <h3 align="center">EpidemyIO</h3>
  <p align="center">
    Небольшое приложение симуляции распространения инфекции среди людей в толпе. Создана для профильного задания стажировки VK
  </p>
</div>

<H2>Оглавление</H2>
<ol>
<li>
  <a href="#о-проекте">О проекте</a>
  <ul>
    <li><a href="#инструменты">Инструменты</a></li>
  </ul>
</li>
<li><a href="#контакты">Контакты</a></li>
</ol>

## О проекте

Это небольшое приложение, которое симулирует распространение инфекции среди толпы людей. Мы указываем размер нашей симуляционной группы, количество новых зараженных при контакте с зараженным и период распространения волны в секундах и наблюдаем как все люди подвергаются заражению неизвестным вирусом. Оно содержит весь основной функционал для подобного рода приложения, а именно процесс симуляции, отображение количество зараженных и возможность заражать любого человека на экране

К сожалению времени хватило не на все запланированные вещи, например вот что можно было бы улучшить или добавить:

Для пользователя:
* Добавить жесты масштабирования для отдаления или приближения толпы путем изменения размеров GridItem'а (Сейчас поле обзора крайне узкое)
* Добавить Swipe жесты для выбора нескольких людей, а не клика по одному человеку
* Добавить отдельное меню с графиками SwiftChart для визуального отображения изменения количества больных и здоровых людей со временем

Логика приложения
* Создавать массив нужного размера не сразу целиком, а лишь частями, подгружая его по мере продвижения заражения или прокрутки экрана
* Доработка логики перерисовки при нажатии на конкретного человека (Текущая цепочка вызовов вызывает перерисовку всего ScrollView, что негативно сказывается на плавности)


<div align="center">
    <h3 align="center">Демонстрационное видео</h3>
    (На записи цвета отображаются некорректно)
  
https://github.com/Oronemu/EpidemyIO/assets/68193170/31b31e86-5aee-4fd2-9fe8-5949b679d64e

</div>

<div align="center">
   <h3 align="center">Скриншоты</h3>

  <img src="https://sun9-34.userapi.com/impg/FyJWhskZ0-HYOfHS2HEyEl_zyvCC7K5KyonlPg/Vub_0wbv_2Q.jpg?size=998x2160&quality=95&sign=405359d57e1e7f655f7d24db126f2f64&type=album" alt="Logo" width="230" height="500">
  <img src="https://sun9-9.userapi.com/impg/JFGlgg7WYjdc6dvFfp4vlXpNMCrY4VjJPeUQxA/gwl9vBDPFtY.jpg?size=998x2160&quality=95&sign=82e811966e32c2181acea3707bd9cefb&type=album" alt="Logo" width="230" height="500">
  <img src="https://sun9-51.userapi.com/impg/eUuyyGtBlFBdEsjUKgReI4MdIvDXVCbXa24CrA/JeeQrMfInQo.jpg?size=998x2160&quality=95&sign=b5ffd03a89d9ff72d9b77c6718d8643a&type=album" alt="Logo" width="230" height="500">
</div>

### Инструменты

* ![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
* ![SwiftUI](https://img.shields.io/badge/swiftui-007ACC?style=for-the-badge&logo=swift&logoColor=white)
* ![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)

<p align="right">(<a href="#о-проекте">Наверх</a>)</p>

## Контакты

Your Name - [VK](https://vk.com/oronemu) - Oronemu@mail.ru

Project Link: https://github.com/Oronemu/EpidemyIO

<p align="right">(<a href="#о-проекте">Наверх</a>)</p>
