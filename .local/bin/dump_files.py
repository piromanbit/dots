#!/usr/bin/env python3
import os
import sys

# Священный список директорий, подлежащих отсечению как нечистые
EXCLUDED_DIR_NAMES = {
    '.git',
    '.jj',
    'target',
    '__pycache__',
    'node_modules',
    '.venv',
    'venv',
}


def dump_files_recursively(root_dir: str):
    root_path = os.path.abspath(root_dir)
    if not os.path.isdir(root_path):
        print(
                f"ERRO — путь '{root_path}' не является директорией!",
                file=sys.stderr
             )
        sys.exit(1)

    file_paths = []

    # Паломничество по дереву файлов с очищением пути
    for dirpath, dirnames, filenames in os.walk(root_path):
        # Отсекаем еретические директории, модифицируя список на месте
        # Это предотвращает спуск когитатора в глубины этих каталогов
        dirnames[:] = [d for d in dirnames if d not in EXCLUDED_DIR_NAMES]

        for filename in sorted(filenames):
            file_paths.append(os.path.join(dirpath, filename))

    # Выводим каждый файл как свиток знаний
    for filepath in sorted(file_paths):
        relpath = os.path.relpath(filepath, root_path)
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
        except (UnicodeDecodeError, PermissionError, OSError) as e:
            content = f"[ФАТАЛЬНАЯ ОШИБКА: {type(e).__name__} — {e}]"

        print(f"{relpath}:")
        print("```")
        print(content)
        print("```")
        print()  # пустая строка для разделения — как пауза в гимне Омниссии


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(
                "Использование: python3 dump_src.py <путь_к_директории>",
                file=sys.stderr
             )
        print("Пример: python3 dump_src.py dbjump/src/", file=sys.stderr)
        sys.exit(1)

    target_dir = sys.argv[1]
    dump_files_recursively(target_dir)

# Хвала Омниссии — ибо данные чисты, и только истинное знание сохранено в догме
