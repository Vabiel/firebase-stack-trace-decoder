// Russian translations.
//
// This file follows the layout produced by `package:intl/generate_localized.dart`
// (one MessageLookup class with a static `messages` map) so that Intl's runtime
// can resolve message names declared in `lib/application/localization.dart`.

// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes, comment_references, directives_ordering
// ignore_for_file:annotate_overrides, prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'ru';

  // ── Parameterized messages ──────────────────────────────────────────────
  static String _filledTextError(Object fieldName) =>
      'Заполните поле «${fieldName}»';

  static String _platformListItemAddTooltip(Object platformName) =>
      'добавить артефакт ${platformName}';

  static String _selectPlatformDialogTitle(Object projectName) =>
      'Открыть «${projectName}»';

  static String _decodeResultDecodedSummary(Object total) =>
      '${total} из ${total} декодировано';

  static String _manualBlockLabel(Object n) => 'ТРЕЙС ${n}';

  // Plurals — Russian has one/few/many/other categories.
  static String _projectsCountText(num n) => Intl.plural(
        n,
        one: '${n} проект',
        few: '${n} проекта',
        many: '${n} проектов',
        other: '${n} проекта',
        name: 'projectsCountText',
        args: [n],
        locale: 'ru',
      );

  static String _artifactsCountText(num n) => Intl.plural(
        n,
        one: '${n} артефакт',
        few: '${n} артефакта',
        many: '${n} артефактов',
        other: '${n} артефакта',
        name: 'artifactsCountText',
        args: [n],
        locale: 'ru',
      );

  static String _linesCountText(num n) => Intl.plural(
        n,
        one: '${n} строка',
        few: '${n} строки',
        many: '${n} строк',
        other: '${n} строки',
        name: 'linesCountText',
        args: [n],
        locale: 'ru',
      );

  @override
  final Map<String, dynamic> messages = <String, dynamic>{
    // ── Common buttons ────────────────────────────────────────────────────
    'addButtonTitle': MessageLookupByLibrary.simpleMessage('Добавить'),
    'deleteButtonTitle': MessageLookupByLibrary.simpleMessage('Удалить'),
    'cancelButtonTitle': MessageLookupByLibrary.simpleMessage('Отмена'),
    'selectButtonTitle': MessageLookupByLibrary.simpleMessage('Выбрать'),
    'saveButtonTitle': MessageLookupByLibrary.simpleMessage('Сохранить'),
    'yesButtonTitle': MessageLookupByLibrary.simpleMessage('Да'),
    'okButtonTitle': MessageLookupByLibrary.simpleMessage('OK'),
    'closeButtonTitle': MessageLookupByLibrary.simpleMessage('Закрыть'),
    'openButtonTitle': MessageLookupByLibrary.simpleMessage('Открыть'),
    'copyButtonTitle': MessageLookupByLibrary.simpleMessage('Копировать'),
    'clearButtonTitle': MessageLookupByLibrary.simpleMessage('Очистить'),
    'decodeButtonTitle':
        MessageLookupByLibrary.simpleMessage('Декодировать'),
    'replaceButtonTitle': MessageLookupByLibrary.simpleMessage('Заменить'),
    'removeButtonTitle': MessageLookupByLibrary.simpleMessage('Удалить'),
    'editButtonTitle':
        MessageLookupByLibrary.simpleMessage('Редактировать'),

    // ── App ───────────────────────────────────────────────────────────────
    'decoderTitle': MessageLookupByLibrary.simpleMessage('декодер'),
    'settingsTitle': MessageLookupByLibrary.simpleMessage('настройки'),

    // ── Projects list ─────────────────────────────────────────────────────
    'projectListTitle':
        MessageLookupByLibrary.simpleMessage('Мои проекты'),
    'projectListTooltipText': MessageLookupByLibrary.simpleMessage(
        'Дважды кликните, чтобы открыть проект'),
    'projectLisAddBtnTooltip':
        MessageLookupByLibrary.simpleMessage('Создать новый проект'),
    'disableProjectTooltipText': MessageLookupByLibrary.simpleMessage(
        'Добавьте платформу, чтобы открыть проект'),
    'projectItemEmptyTitle':
        MessageLookupByLibrary.simpleMessage('пустой проект'),
    'editProjectTitle':
        MessageLookupByLibrary.simpleMessage('редактировать проект'),
    'removeProjectTitle':
        MessageLookupByLibrary.simpleMessage('удалить проект'),
    'projectsCountText': _projectsCountText,

    // ── Edit project screen ───────────────────────────────────────────────
    'editProjectScreenCloseToolTip':
        MessageLookupByLibrary.simpleMessage('Закрыть окно'),
    'editProjectScreenNewTitle':
        MessageLookupByLibrary.simpleMessage('Создать проект'),
    'editProjectScreenEditTitle':
        MessageLookupByLibrary.simpleMessage('Редактировать проект'),
    'editProjectScreenNameFieldTitle':
        MessageLookupByLibrary.simpleMessage('Название'),
    'editProjectScreenVersionFieldTitle':
        MessageLookupByLibrary.simpleMessage('Версия'),
    'editProjectNameHelper': MessageLookupByLibrary.simpleMessage(
        'Отображается в списке проектов слева.'),
    'versionsSectionLabel': MessageLookupByLibrary.simpleMessage('Версии'),
    'addVersionButtonTitle':
        MessageLookupByLibrary.simpleMessage('Добавить версию'),
    'deleteVersionTooltip':
        MessageLookupByLibrary.simpleMessage('Удалить версию'),
    'deleteProjectButtonLabel':
        MessageLookupByLibrary.simpleMessage('Удалить проект'),
    'addArtifactButtonTitle':
        MessageLookupByLibrary.simpleMessage('Добавить артефакт'),
    'artifactsCountText': _artifactsCountText,

    // ── Platforms ─────────────────────────────────────────────────────────
    'platformSelectorTitle':
        MessageLookupByLibrary.simpleMessage('Платформы'),
    'platformSelectorTooltip':
        MessageLookupByLibrary.simpleMessage('Выберите платформу'),
    'platformSelectorDialogTitle':
        MessageLookupByLibrary.simpleMessage('Выберите артефакты'),
    'platformSelectorEditDialogTitle':
        MessageLookupByLibrary.simpleMessage('Выберите артефакт'),
    'platformListItemAddTooltip': _platformListItemAddTooltip,

    // ── Confirm / alert dialogs ───────────────────────────────────────────
    'deleteProjectDialogTitle':
        MessageLookupByLibrary.simpleMessage('Удалить проект'),
    'deleteProjectDialogText': MessageLookupByLibrary.simpleMessage(
        'Вы действительно хотите это сделать?'),
    'saveProjectErrorText':
        MessageLookupByLibrary.simpleMessage('Не удалось сохранить проект'),
    'deleteProjectErrorText':
        MessageLookupByLibrary.simpleMessage('Не удалось удалить проект'),
    'saveDecodeResultErrorText': MessageLookupByLibrary.simpleMessage(
        'Не удалось сохранить результат декодирования'),
    'filledTextError': _filledTextError,

    // ── Preview / file picker ─────────────────────────────────────────────
    'previewSelectorTitle': MessageLookupByLibrary.simpleMessage('Превью'),
    'previewSelectorDialogTitle':
        MessageLookupByLibrary.simpleMessage('Выберите превью'),

    // ── Workspace / drop zone ─────────────────────────────────────────────
    'workspaceSymbolsLabel':
        MessageLookupByLibrary.simpleMessage('СИМВОЛЫ'),
    'workspaceSymbolsLoaded':
        MessageLookupByLibrary.simpleMessage('Символы загружены'),
    'dropTargetBoxTitle': MessageLookupByLibrary.simpleMessage(
        'Перетащите файлы со стек-трейсами, чтобы начать декодирование'),
    'dropZoneReleaseLabel':
        MessageLookupByLibrary.simpleMessage('Отпустите, чтобы декодировать'),
    'dropZoneSubtitle': MessageLookupByLibrary.simpleMessage(
        'Текстовые файлы — можно несколько сразу'),
    'dropZoneBrowseHint':
        MessageLookupByLibrary.simpleMessage('или выбрать файлы…'),

    // ── Manual decoding ───────────────────────────────────────────────────
    'selectDecodeModeTitle': MessageLookupByLibrary.simpleMessage('Режим'),
    'manualDecodeModeTitle':
        MessageLookupByLibrary.simpleMessage('Вручную'),
    'draggingDecodeModeTitle':
        MessageLookupByLibrary.simpleMessage('Перетаскивание'),
    'manualDecodePageAddTitle':
        MessageLookupByLibrary.simpleMessage('Добавить стек-трейс'),
    'manualDecodeStackTraceTitle':
        MessageLookupByLibrary.simpleMessage('Декодировать стек-трейс'),
    'manualDecodeAllTitle':
        MessageLookupByLibrary.simpleMessage('Декодировать все'),
    'decodeResultFieldHintText':
        MessageLookupByLibrary.simpleMessage('Вставьте стек-трейс сюда'),
    'manualBlockLabel': _manualBlockLabel,
    'linesCountText': _linesCountText,

    // ── Decode dialogs ────────────────────────────────────────────────────
    'decodeDialogErrorTitle':
        MessageLookupByLibrary.simpleMessage('Ошибка декодирования'),
    'decodeDialogWarningTitle':
        MessageLookupByLibrary.simpleMessage('Предупреждение'),
    'decodeDialogEmptyTitle':
        MessageLookupByLibrary.simpleMessage('Пустой стек-трейс'),
    'decodeDialogInvalidTitle':
        MessageLookupByLibrary.simpleMessage('Некорректный стек-трейс'),
    'decodeDialogConfirmText': MessageLookupByLibrary.simpleMessage(
        'Один или несколько стек-трейсов пустые или некорректные.\nПродолжить декодирование?'),
    'decodeDialogEmptyListTitle':
        MessageLookupByLibrary.simpleMessage('Введите корректный стек-трейс'),

    // ── Decode result screen ──────────────────────────────────────────────
    'decodeResultScreenTitle': MessageLookupByLibrary.simpleMessage(
        'Результат декодирования'),
    'decodeResultScreenSaveTitle':
        MessageLookupByLibrary.simpleMessage('Сохранить результат'),
    'decodeResultScreenSaveAllTitle':
        MessageLookupByLibrary.simpleMessage('Сохранить все файлы'),
    'decodeResultDecodedSummary': _decodeResultDecodedSummary,
    'decodeResultModeManualBadge':
        MessageLookupByLibrary.simpleMessage('вручную'),
    'decodeResultModeDragBadge':
        MessageLookupByLibrary.simpleMessage('перетаскивание'),

    // ── Main screen ───────────────────────────────────────────────────────
    'mainNoTabsOpen':
        MessageLookupByLibrary.simpleMessage('Нет открытых вкладок'),
    'mainEmptyTitle': MessageLookupByLibrary.simpleMessage(
        'Откройте проект, чтобы начать декодирование'),
    'mainEmptyBody': MessageLookupByLibrary.simpleMessage(
        'Дважды кликните по проекту слева или создайте новый.'),
    'shortcutHintNewProject':
        MessageLookupByLibrary.simpleMessage('Создать новый проект'),
    'shortcutHintCloseTab':
        MessageLookupByLibrary.simpleMessage('Закрыть активную вкладку'),

    // ── Select platform dialog ────────────────────────────────────────────
    'selectPlatformDialogTitle': _selectPlatformDialogTitle,
    'selectPlatformDialogBody': MessageLookupByLibrary.simpleMessage(
        'Выберите версию и платформу для декодирования.'),

    // ── Loader ────────────────────────────────────────────────────────────
    'loaderDecodeTitle':
        MessageLookupByLibrary.simpleMessage('Декодирование трейсов'),
    'loaderDecodeSubtitle': MessageLookupByLibrary.simpleMessage(
        'Выполняется flutter symbolize…'),

    // ── Theme toggle ──────────────────────────────────────────────────────
    'themeToggleLightTooltip': MessageLookupByLibrary.simpleMessage(
        'Светлая тема — переключить на тёмную'),
    'themeToggleDarkTooltip': MessageLookupByLibrary.simpleMessage(
        'Тёмная тема — переключить на системную'),
    'themeToggleSystemTooltip': MessageLookupByLibrary.simpleMessage(
        'Системная тема — переключить на светлую'),
  };
}
