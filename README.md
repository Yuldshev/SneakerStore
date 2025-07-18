![Cover](_sources/cover.jpg)
# SneakerStore

## О проектe
**SneakerStore** — это нативное iOS-приложение для просмотра каталога кроссовок. Приложение демонстрирует современный подход к разработке на Swift и SwiftUI, с чистой архитектурой и разделением ответственности.

## Функционал
<details>
  <summary> Details (Click to expand) </summary>
  <br>

- **Каталог товаров:** Просмотр списка доступных кроссовок.
- **Детальная информация:** Просмотр подробной информации о каждой модели.
- **Корзина:** Добавление товаров в корзину.
- **Избранное:** Возможность добавлять понравившиеся модели в список избранного.
</details>


## Стек
<details>
  <summary> Details (Click to expand) </summary>
  <br>
    
### Проект построен с использованием современных практик и паттернов проектирования:
- **Язык:** Swift
- **UI Framework:** SwiftUI
- **Архитектурный паттерн:** MVI
- **Навигация:** Используется `Router` для управления переходами между экранами.
- **Внедрение зависимостей (DI):** Централизованное управление зависимостями через `DIContainer` и `VMFactory`.
- **Сервисный слой:** Бизнес-логика инкапсулирована в сервисах (`SneakersService`, `CartService`, `FavoriteService`).
- **Сеть:** Асинхронное взаимодействие с API для получения данных о товарах.
- **Кэширование:** Реализован `CacheService` для локального сохранения данных и улучшения производительности.
</details>

## Экраны
<details>
  <summary> Details (Click to expand) </summary>
  <br>
    
| ![](_sources/CatalogPage.png) | ![](_sources/BrandPage.png) | ![](_sources/SneakerPage.png) |
|-------------------|-------------------|-------------------|
| ![](_sources/FavPage.png) | ![](_sources/CartPage.png) | ![](_sources/BrowsePage.png)
</details>


## Структура проекта
<details>
  <summary> Details (Click to expand) </summary>
  <br>
    
```bash
SneakerStore/
├── Application/       # Точка входа, роутер, Tabbar
├── Features/          # Основные экраны и фичи приложения
│   ├── Browse/        # Просмотр и фильтрация
│   ├── Cart/          # Корзина
│   ├── Catalog/       # Главный каталог
│   ├── Favorites/     # Избранное
│   └── SneakerDetail/ # Детальный экран
└── Shared/            # Общие компоненты
    ├── DI/            # Внедрение зависимостей
    ├── Models/        # Модели данных (DTO и локальные)
    ├── Network/       # Сетевой слой
    ├── Services/      # Сервисы бизнес-логики
    ├── UI/            # Переиспользуемые UI-компоненты и расширения
    └── Utils/         # Вспомогательные утилиты
```
</details>


## Как запустить
<details>
  <summary> Details (Click to expand) </summary>
  <br>
    
1.  Клонируйте репозиторий.
2.  Откройте файл `SneakerStore.xcodeproj` в Xcode.
3.  Выберите нужный симулятор или реальное устройство.
4.  Нажмите **Build and Run** (сочетание клавиш `Cmd+R`).
</details>

