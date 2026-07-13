import { getBenchmarkLaunch } from '../runtime/BenchmarkLaunch';

interface FileRow {
  name: string;
  date: string;
  kind: string;
}

interface DrawerRow {
  title: string;
  summary: string;
  icon: Resource;
  actionIcon?: Resource;
  actionLabel?: string;
  selected?: boolean;
  dividerAfter?: boolean;
}

interface PreferenceRow {
  title: string;
  summary: string;
  control: string;
  checked?: boolean;
}

const PRIMARY: string = '#3F51B5';
const PRIMARY_DARK: string = '#3949AB';
const ACCENT: string = '#E91E63';
const TEXT_PRIMARY: string = '#212121';
const TEXT_SECONDARY: string = '#757575';
const DIVIDER: string = '#D6D6D6';
const SURFACE: string = '#FFFFFF';
const PAGE_BG: string = '#FAFAFA';
const SCRIM: string = '#66000000';
const EDITOR_FIXTURE_TEXT: string = 'Amaze sample note with resume resume markers';

const MAIN_STATES: string[] = [
  'main_default',
  'main_drawer_open',
  'main_fab_menu',
  'main_context_menu',
  'main_grid_view',
  'quick_access',
  'recent_files',
  'images_smart',
  'search_empty',
  'search_results',
  'search_no_results',
  'compress_dialog',
  'new_folder_dialog',
  'new_file_dialog',
  'folder_open',
  'archive_mode',
  'utilities_prompt',
  'paste_mode',
  'delete_confirm',
  'restore_confirm'
];

@Entry
@Component
struct Index {
  @State private stateId: string = 'main_default';
  @State private actionStatus: string = '';
  @State private actionTick: number = 0;
  @State private currentFolderTitle: string = 'Alarms';
  @State private currentFolderSegments: string[] = [];
  @State private archiveSelected: boolean = false;
  @State private lastPreferenceTitle: string = '';
  @State private lastPreferenceEnabled: boolean = false;
  @State private lastPreferenceValue: string = '';
  @State private selectionMode: boolean = false;
  @State private selectionScope: string = 'main_default';
  @State private selectedNames: string[] = [];
  @State private selectionAnchorNames: string[] = [];
  @State private selectionCriteriaOpen: boolean = false;
  @State private editorText: string = EDITOR_FIXTURE_TEXT;

  private readonly files: FileRow[] = [
    { name: 'Alarms', date: 'Jun 25 | 1:32 PM', kind: 'folder' },
    { name: 'Android', date: 'Jun 25 | 1:32 PM', kind: 'folder' },
    { name: 'Audiobooks', date: 'Jun 25 | 1:32 PM', kind: 'folder' },
    { name: 'DCIM', date: 'Jun 25 | 1:32 PM', kind: 'folder' },
    { name: 'Documents', date: 'Jun 25 | 1:39 PM', kind: 'folder' },
    { name: 'Download', date: 'Jun 25 | 1:39 PM', kind: 'folder' },
    { name: 'Movies', date: 'Jun 25 | 1:44 PM', kind: 'folder' },
    { name: 'Music', date: 'Jun 25 | 1:45 PM', kind: 'folder' },
    { name: 'Pictures', date: 'Jun 25 | 1:46 PM', kind: 'folder' },
    { name: 'Podcasts', date: 'Jun 25 | 1:47 PM', kind: 'folder' },
    { name: 'Ringtones', date: 'Jun 25 | 1:48 PM', kind: 'folder' },
    { name: 'Screenshots', date: 'Jun 25 | 1:49 PM', kind: 'folder' },
    { name: 'Notifications', date: 'Jun 25 | 1:50 PM', kind: 'folder' },
    { name: 'sample.zip', date: 'Jun 25 | 1:40 PM', kind: 'file' }
  ];

  private readonly folderFiles: FileRow[] = [
    { name: 'Subfolder', date: 'Jun 25 | 1:42 PM', kind: 'folder' },
    { name: 'Nested', date: 'Jun 25 | 1:42 PM', kind: 'folder' },
    { name: 'readme.txt', date: 'Jun 25 | 1:43 PM', kind: 'file' }
  ];

  private readonly quickAccessFiles: FileRow[] = [
    { name: 'Download', date: 'Quick access | Folder', kind: 'folder' },
    { name: 'Documents', date: 'Quick access | Folder', kind: 'folder' },
    { name: 'Pictures', date: 'Quick access | Folder', kind: 'folder' },
    { name: 'resume.pdf', date: 'Quick access | File', kind: 'file' },
    { name: 'sample.zip', date: 'Quick access | File', kind: 'file' }
  ];

  private readonly recentFiles: FileRow[] = [
    { name: 'test.apk', date: 'Recent files | Jun 25 | 1:46 PM', kind: 'file' },
    { name: 'test.mp3', date: 'Recent files | Jun 25 | 1:45 PM', kind: 'file' },
    { name: 'test.mp4', date: 'Recent files | Jun 25 | 1:44 PM', kind: 'file' },
    { name: 'test.pdf', date: 'Recent files | Jun 25 | 1:43 PM', kind: 'file' },
    { name: 'test.jpg', date: 'Recent files | Jun 25 | 1:42 PM', kind: 'file' }
  ];

  private readonly imageFiles: FileRow[] = [
    { name: 'test.jpg', date: 'Images | Jun 25 | 1:42 PM', kind: 'file' }
  ];

  private readonly drawerRows: DrawerRow[] = [
    {
      title: 'Internal Storage',
      summary: '5.47 GB free of 6.23 GB',
      icon: $r('app.media.ic_phone_android_white_24dp'),
      actionIcon: $r('app.media.ic_show_chart_black_24dp'),
      actionLabel: 'Analyse storage',
      selected: true,
      dividerAfter: true
    },
    {
      title: 'DCIM',
      summary: '',
      icon: $r('app.media.ic_folder_white_24dp'),
      actionIcon: $r('app.media.ic_edit_24dp'),
      actionLabel: 'Edit DCIM'
    },
    {
      title: 'Download',
      summary: '',
      icon: $r('app.media.ic_folder_white_24dp'),
      actionIcon: $r('app.media.ic_edit_24dp'),
      actionLabel: 'Edit Download'
    },
    {
      title: 'Movies',
      summary: '',
      icon: $r('app.media.ic_folder_white_24dp'),
      actionIcon: $r('app.media.ic_edit_24dp'),
      actionLabel: 'Edit Movies'
    },
    {
      title: 'Music',
      summary: '',
      icon: $r('app.media.ic_folder_white_24dp'),
      actionIcon: $r('app.media.ic_edit_24dp'),
      actionLabel: 'Edit Music'
    },
    {
      title: 'Pictures',
      summary: '',
      icon: $r('app.media.ic_folder_white_24dp'),
      actionIcon: $r('app.media.ic_edit_24dp'),
      actionLabel: 'Edit Pictures',
      dividerAfter: true
    },
    { title: 'Quick access', summary: '', icon: $r('app.media.ic_star_white_24dp') },
    { title: 'Recent files', summary: '', icon: $r('app.media.ic_history_white_24dp') },
    { title: 'Images', summary: '', icon: $r('app.media.ic_photo_library_white_24dp') },
    { title: 'FTP Server', summary: '', icon: $r('app.media.ic_cloud_white_24dp') },
    { title: 'Trash Bin', summary: '', icon: $r('app.media.round_delete_outline_24') },
    { title: 'Settings', summary: '', icon: $r('app.media.ic_settings_white_24dp') }
  ];

  private readonly settingsRoot: PreferenceRow[] = [
    { title: 'Appearance', summary: 'Customize the theme, colors and appearance of the file manager', control: 'settings_appearance' },
    { title: 'Interface', summary: 'Control what information to show, customize the sidebar, and toggle UI preferences', control: 'settings_ui' },
    { title: 'Behavior', summary: 'Modify behaviors such as advanced search and whether to open files as a new task', control: 'settings_behavior' },
    { title: 'Security', summary: 'Set up password and encryption', control: 'settings_security' },
    { title: 'Backup', summary: 'Export/Import Amaze settings', control: 'settings_backup' },
    { title: 'About Amaze File Manager', summary: '', control: '' },
    { title: 'Send Feedback', summary: '', control: '' }
  ];

  private readonly appearanceRows: PreferenceRow[] = [
    { title: 'Theme', summary: 'System (follow system theme)', control: 'value' },
    { title: 'Follow battery saver', summary: 'If selected and the battery saver mode is turned on, the theme changes to dark theme', control: 'switch', checked: false },
    { title: 'Use circular icons', summary: 'Use circular icons for images and videos', control: 'switch', checked: true },
    { title: 'Intellihide Toolbar', summary: 'Automatically hide toolbar while scrolling', control: 'switch', checked: true },
    { title: 'Number of columns in grid view', summary: '3', control: 'value' },
    { title: 'Show Dividers', summary: '', control: 'switch', checked: true },
    { title: 'Show Headers', summary: '', control: 'switch', checked: true },
    { title: 'Enable marquee filename', summary: 'Scroll long file names in list rows', control: 'switch', checked: false },
    { title: 'Select color config', summary: 'Open color configuration presets', control: 'settings_color' },
    { title: 'Colorize icons', summary: 'Tint file and folder icons using the active palette', control: 'switch', checked: false }
  ];

  private readonly colorRows: PreferenceRow[] = [
    { title: 'Preselected configs', summary: 'Material Blue selected', control: 'value' },
    { title: 'Primary color', summary: '#3F51B5', control: 'value' },
    { title: 'Secondary color', summary: '#3949AB', control: 'value' },
    { title: 'Accent color', summary: '#E91E63', control: 'value' },
    { title: 'Icon color', summary: '#607D8B', control: 'value' }
  ];

  private readonly interfaceRows: PreferenceRow[] = [
    { title: 'App Language', summary: 'System Default', control: 'value' },
    { title: 'Show Thumbnails', summary: 'Show Thumbnails of apps and images', control: 'switch', checked: true },
    { title: 'Show Hidden Files and Folders', summary: '', control: 'switch', checked: false },
    { title: 'Show Last Modified Date and Time', summary: 'Show the date and time of last modification', control: 'switch', checked: true },
    { title: 'Show Sizes', summary: 'Show size of files and number of items in folders', control: 'switch', checked: true },
    { title: 'Back navigation', summary: 'Enables custom back navigation at top of the list', control: 'switch', checked: false },
    { title: 'Drag and drop preference', summary: 'Enable drag and drop in file lists', control: 'switch', checked: false },
    { title: 'Sidebar bookmarks screen', summary: 'Customize bookmark drawer rows', control: 'settings_bookmarks' },
    { title: 'Sidebar quick access screen', summary: 'Customize quick access drawer rows', control: 'settings_quick_access' }
  ];

  private readonly bookmarkRows: PreferenceRow[] = [
    { title: 'Enable bookmarks section', summary: 'Bookmarks section visible in the navigation drawer', control: 'switch', checked: true },
    { title: 'Documents', summary: '/storage/emulated/0/Documents', control: 'value' },
    { title: 'Add bookmark', summary: 'Drawer bookmark placeholder', control: 'value' },
    { title: 'Edit bookmark', summary: 'Drawer bookmark placeholder', control: 'value' },
    { title: 'Delete bookmark', summary: 'Drawer bookmark placeholder', control: 'value' }
  ];

  private readonly quickAccessRows: PreferenceRow[] = [
    { title: 'Enable quick access section', summary: 'Quick access section visible in the navigation drawer', control: 'switch', checked: true },
    { title: 'Fast access switch', summary: 'Quick access drawer row', control: 'switch', checked: true },
    { title: 'Recent switch', summary: 'Recent files drawer row', control: 'switch', checked: true },
    { title: 'Images switch', summary: 'Images drawer row', control: 'switch', checked: true },
    { title: 'Videos switch', summary: 'Videos drawer row', control: 'switch', checked: false },
    { title: 'Audio switch', summary: 'Audio drawer row', control: 'switch', checked: false },
    { title: 'Documents switch', summary: 'Documents drawer row', control: 'switch', checked: true },
    { title: 'APKs switch', summary: 'APKs drawer row', control: 'switch', checked: false }
  ];

  private readonly behaviorRows: PreferenceRow[] = [
    { title: 'Remember paths', summary: 'When starting up, the most recently viewed folder for each tab will be displayed', control: 'switch', checked: true },
    { title: 'Custom paths', summary: 'Long press path bar to type a custom path', control: 'switch', checked: false },
    { title: 'Open files as new task', summary: 'Allows you to open files in separate tasks. Access them from system recents screen.', control: 'switch', checked: false },
    { title: 'Clear cache', summary: 'Clears selected default file opening apps', control: 'value' },
    { title: 'Disable player intent filters', summary: 'Disables Amaze inbuilt media players from file chooser', control: 'switch', checked: false },
    { title: 'Archive Extract Folder', summary: 'Archive files will be extracted to this folder. Default value is the directory in which archive is present.', control: 'value' },
    { title: 'Retention number of files', summary: '100 files', control: 'value' },
    { title: 'Retention days', summary: '30 days', control: 'value' },
    { title: 'Retention bytes', summary: '512 MB', control: 'value' },
    { title: 'Cleanup interval', summary: '24 hours', control: 'value' },
    { title: 'Delete confirmation', summary: 'Ask before deleting files', control: 'switch', checked: true },
    { title: 'Delete permanently without confirmation', summary: 'Do not ask before permanent delete', control: 'switch', checked: false },
    { title: 'Regular expression', summary: 'Use regex matching in search parameters', control: 'switch', checked: false },
    { title: 'Match content', summary: 'Search inside file contents', control: 'switch', checked: false },
    { title: 'Legacy listing', summary: 'Use legacy file listing implementation', control: 'switch', checked: false }
  ];

  private readonly securityRows: PreferenceRow[] = [
    { title: 'Master Password', summary: 'Set a master password for encryption. Leave empty to remove.', control: '' },
    { title: 'Fingerprint', summary: 'Use fingerprint to authenticate encryption', control: 'switch' }
  ];

  private readonly backupRows: PreferenceRow[] = [
    { title: 'Export', summary: 'Export settings', control: '' },
    { title: 'Import', summary: 'Import settings', control: '' }
  ];

  aboutToAppear(): void {
    this.resetScenarioState(this.stateForBenchmarkSurface(getBenchmarkLaunch().surface));
  }

  private stateForBenchmarkSurface(surface: string): string {
    const states: Record<string, string> = {
      'home': 'main_default',
      'folder': 'folder_open',
      'text_editor': 'text_editor',
      'archive': 'archive_mode',
      'about': 'about_page',
      'settings': 'settings_root',
      'settings_appearance': 'settings_appearance',
      'settings_interface': 'settings_ui',
      'settings_behavior': 'settings_behavior',
      'settings_bookmarks': 'settings_bookmarks',
      'settings_security': 'settings_security',
      'settings_backup': 'settings_backup',
      'trash': 'trash_bin',
      'ftp_server': 'ftp_server'
    };
    return states[surface] ? states[surface] : 'main_default';
  }

  private resetScenarioState(targetState: string = 'main_default'): void {
    this.stateId = targetState;
    this.actionStatus = '';
    this.actionTick = 0;
    this.currentFolderTitle = 'Alarms';
    this.currentFolderSegments = [];
    this.archiveSelected = false;
    this.selectionMode = false;
    this.selectionScope = 'main_default';
    this.selectedNames = [];
    this.selectionAnchorNames = [];
    this.selectionCriteriaOpen = false;
    this.editorText = EDITOR_FIXTURE_TEXT;
  }

  private setState(state: string): void {
    if (state === 'main_default' && !this.selectionMode) {
      this.actionStatus = '';
    }
    this.stateId = state;
  }

  private recordAction(_label: string): void {
    this.actionTick += 1;
    this.actionStatus = '';
  }

  private handleRefresh(): void {
    this.recordAction('List refreshed');
  }

  private setActionState(state: string, label: string): void {
    this.setState(state);
    this.recordAction(label);
  }

  private openWholeArchiveExtract(): void {
    this.setState('archive_extract_dialog');
    this.recordAction('Compressed File explorer Extract whole opened archive affected');
  }

  private navigateState(state: string): void {
    this.actionStatus = '';
    this.setState(state);
  }

  private parentForState(state: string): string {
    if (state === 'main_default') {
      return 'main_default';
    }
    if (state === 'settings_root') {
      return 'main_default';
    }
    if (state.startsWith('settings_') || state.startsWith('setting_action_') ||
      state === 'about_page' || state === 'about_licenses' || state === 'license_list') {
      if (state === 'settings_color') {
        return 'settings_appearance';
      }
      if (state === 'settings_bookmarks' || state === 'settings_quick_access') {
        return 'settings_ui';
      }
      if (state === 'license_list') {
        return 'about_licenses';
      }
      if (state === 'about_licenses') {
        return 'about_page';
      }
      if (state === 'about_page') {
        return 'settings_root';
      }
      return 'settings_root';
    }
    if (state === 'text_monospace' || state === 'open_as_sheet' || state === 'text_details_sheet' ||
      state === 'text_unsaved_dialog') {
      return 'text_editor';
    }
    if (state === 'archive_extract_dialog') {
      return 'archive_mode';
    }
    if (state === 'properties_sheet' || state === 'rename_dialog' || state === 'sort_sheet' ||
      state === 'storage_analysis' || state === 'cloud_connection') {
      return 'main_default';
    }
    if (state === 'folder_open') {
      return this.currentFolderSegments.length > 1 ? 'folder_open' : 'main_default';
    }
    if (state === 'main_drawer_open' || state === 'main_fab_menu' ||
      state === 'main_context_menu' || state === 'main_grid_view' || state === 'search_empty' ||
      state === 'search_results' || state === 'search_no_results' || state === 'quick_access' ||
      state === 'recent_files' || state === 'images_smart' || state === 'ftp_server' ||
      state === 'trash_bin' || state === 'bookmark_edit' || state === 'text_editor' ||
      state === 'archive_mode' || state === 'utilities_prompt') {
      return 'main_default';
    }
    if (this.isOverlayState()) {
      return 'main_default';
    }
    return 'main_default';
  }

  private goBack(): void {
    if (this.stateId === 'main_default') {
      this.recordAction('Back press again to exit');
      return;
    }
    if (this.stateId === 'folder_open') {
      this.navigateFolderUp();
      return;
    }
    this.setState(this.parentForState(this.stateId));
  }

  private openFolder(title: string): void {
    this.clearSelectionState(false);
    const folderTitle: string = this.normalizeFolderTitle(title);
    if (this.stateId === 'folder_open') {
      const existingIndex: number = this.currentFolderSegments.indexOf(folderTitle);
      if (existingIndex >= 0) {
        this.currentFolderSegments = this.currentFolderSegments.slice(0, existingIndex + 1);
      } else {
        this.currentFolderSegments = [...this.currentFolderSegments, folderTitle];
      }
    } else {
      this.currentFolderSegments = [folderTitle];
    }
    this.currentFolderTitle = folderTitle;
    this.setState('folder_open');
  }

  private normalizeFolderTitle(title: string): string {
    if (title === 'Drawer bookmark placeholder') {
      return 'Documents';
    }
    return title;
  }

  private navigateFolderUp(): void {
    this.clearSelectionState(false);
    if (this.currentFolderSegments.length > 1) {
      this.currentFolderSegments = this.currentFolderSegments.slice(0, this.currentFolderSegments.length - 1);
      this.currentFolderTitle = this.currentFolderSegments[this.currentFolderSegments.length - 1];
      this.setState('folder_open');
      return;
    }
    this.currentFolderSegments = [];
    this.currentFolderTitle = 'Alarms';
    this.setState('main_default');
  }

  private currentFolderRows(): FileRow[] {
    if (this.currentFolderSegments.length <= 1) {
      return this.folderFiles;
    }
    return [];
  }

  private currentFolderPath(): string {
    if (this.stateId === 'quick_access') {
      return '/storage/emulated/0/Quick access';
    }
    if (this.stateId === 'recent_files') {
      return '/storage/emulated/0/Recent files';
    }
    if (this.stateId === 'images_smart') {
      return '/storage/emulated/0/Images';
    }
    if (this.stateId !== 'folder_open' || this.currentFolderSegments.length === 0) {
      return '/storage/emulated/0';
    }
    return `/storage/emulated/0/${this.currentFolderSegments.join('/')}`;
  }

  private folderCountText(rows: FileRow[]): string {
    const folderCount: number = rows.filter((row: FileRow) => row.kind === 'folder').length;
    const fileCount: number = rows.filter((row: FileRow) => row.kind !== 'folder').length;
    return `${folderCount} folders and ${fileCount} files`;
  }

  private openDrawerRow(row: DrawerRow): void {
    if (row.title === 'Settings') {
      this.navigateState('settings_root');
    } else if (row.title === 'FTP Server') {
      this.navigateState('ftp_server');
    } else if (row.title === 'Trash Bin') {
      this.navigateState('trash_bin');
    } else if (row.title === 'Quick access') {
      this.navigateState('quick_access');
    } else if (row.title === 'Recent files') {
      this.navigateState('recent_files');
    } else if (row.title === 'Images') {
      this.navigateState('images_smart');
    } else {
      this.openFolder(row.title);
    }
  }

  private openDrawerAction(row: DrawerRow): void {
    if (row.title === 'Internal Storage') {
      this.setActionState('storage_analysis', row.actionLabel ? row.actionLabel : 'Analyse storage');
    } else {
      this.setActionState('bookmark_edit', row.actionLabel ? row.actionLabel : `Edit ${row.title}`);
    }
  }

  private openFileRow(item: FileRow): void {
    if (this.selectionMode && (this.stateId === 'main_default' || this.stateId === 'folder_open')) {
      this.selectFileRow(item);
      return;
    }
    if (this.stateId === 'archive_mode') {
      if (item.kind === 'folder') {
        this.currentFolderTitle = item.name;
        this.recordAction(`Archive folder ${item.name}`);
      } else {
        this.setActionState('open_as_sheet', item.name);
      }
      return;
    }
    if (this.stateId === 'trash_bin') {
      this.setActionState('restore_confirm', item.name);
      return;
    }
    if (item.kind === 'folder') {
      this.openFolder(item.name);
    } else if (item.name.endsWith('.zip')) {
      this.setActionState('archive_mode', item.name);
    } else {
      this.setActionState('text_editor', item.name);
    }
  }

  private selectFileRow(item: FileRow): void {
    if (this.stateId === 'archive_mode') {
      this.recordAction('Archive item selection');
      return;
    }
    if (this.stateId === 'trash_bin') {
      this.recordAction(`${item.name} selected in trash`);
      return;
    }
    this.enterSelectionModeForCurrentSurface();
    this.selectedNames = [];
    this.selectionAnchorNames = [];
    this.selectionCriteriaOpen = false;
    this.updateSelectionStatus();
  }

  private openFileRowOptions(item: FileRow): void {
    if (this.stateId === 'trash_bin') {
      this.setActionState('restore_confirm', item.name);
      return;
    }
    if (this.stateId === 'archive_mode') {
      this.setActionState('archive_extract_dialog', item.name);
      return;
    }
    if (this.selectionMode) {
      this.openSelectionMenu();
    } else {
      this.setState('main_context_menu');
    }
  }

  private handlePreference(row: PreferenceRow): void {
    if (row.control.indexOf('settings_') === 0) {
      this.setActionState(row.control, row.title);
    } else if (row.title === 'About Amaze File Manager') {
      this.navigateState('about_page');
    } else if (row.title === 'App Language' || row.title === 'Theme' || row.title.indexOf('columns') >= 0) {
      this.setActionState(`setting_action_${this.stateToken(row.title)}`, row.title);
    } else {
      this.recordAction(row.title);
    }
  }

  private preferenceChecked(row: PreferenceRow): boolean {
    if (this.lastPreferenceTitle === row.title && this.lastPreferenceValue.length > 0) {
      return this.lastPreferenceEnabled;
    }
    return row.checked === true;
  }

  private preferenceSummary(row: PreferenceRow): string {
    if (this.lastPreferenceTitle === row.title && this.lastPreferenceValue.length > 0) {
      if (row.control === 'switch') {
        return `${row.summary.length > 0 ? row.summary + ' - ' : ''}${this.lastPreferenceValue}`;
      }
      return this.lastPreferenceValue;
    }
    return row.summary;
  }

  private nextPreferenceValue(row: PreferenceRow): string {
    if (row.title === 'Number of columns in grid view') {
      return this.lastPreferenceTitle === row.title && this.lastPreferenceValue === '4 columns' ? '3 columns' : '4 columns';
    }
    if (row.title === 'Preselected configs') {
      return this.lastPreferenceTitle === row.title && this.lastPreferenceValue === 'Ocean config selected' ? 'Material Blue selected' : 'Ocean config selected';
    }
    if (row.title === 'Primary color') {
      return this.lastPreferenceTitle === row.title && this.lastPreferenceValue === '#009688' ? '#3F51B5' : '#009688';
    }
    if (row.title === 'Secondary color') {
      return this.lastPreferenceTitle === row.title && this.lastPreferenceValue === '#00695C' ? '#3949AB' : '#00695C';
    }
    if (row.title === 'Accent color') {
      return this.lastPreferenceTitle === row.title && this.lastPreferenceValue === '#FF9800' ? '#E91E63' : '#FF9800';
    }
    if (row.title === 'Icon color') {
      return this.lastPreferenceTitle === row.title && this.lastPreferenceValue === '#4CAF50' ? '#607D8B' : '#4CAF50';
    }
    if (row.title === 'Retention number of files') {
      return this.lastPreferenceTitle === row.title && this.lastPreferenceValue === '200 files' ? '100 files' : '200 files';
    }
    if (row.title === 'Retention days') {
      return this.lastPreferenceTitle === row.title && this.lastPreferenceValue === '60 days' ? '30 days' : '60 days';
    }
    if (row.title === 'Retention bytes') {
      return this.lastPreferenceTitle === row.title && this.lastPreferenceValue === '1 GB' ? '512 MB' : '1 GB';
    }
    if (row.title === 'Cleanup interval') {
      return this.lastPreferenceTitle === row.title && this.lastPreferenceValue === '12 hours' ? '24 hours' : '12 hours';
    }
    if (row.title === 'Archive Extract Folder') {
      return this.lastPreferenceTitle === row.title && this.lastPreferenceValue === '/Download' ? 'Current archive folder' : '/Download';
    }
    return row.summary.length > 0 ? `${row.summary} updated` : 'Updated';
  }

  private handleArchiveAction(label: string): void {
    if (label === 'Select all') {
      this.recordAction(label);
    } else if (label === 'Extract selected') {
      this.setActionState('archive_extract_dialog', label);
    } else if (label === 'Whole-archive extract') {
      this.openWholeArchiveExtract();
    } else {
      this.recordAction(label);
    }
  }

  private clearSelectionState(updateStatus: boolean = true): void {
    this.selectionMode = false;
    this.selectedNames = [];
    this.selectionAnchorNames = [];
    this.selectionCriteriaOpen = false;
    this.selectionScope = 'main_default';
    if (updateStatus) {
      this.actionStatus = 'Selection cleared';
    }
  }

  private isFolderSurfaceActive(): boolean {
    return this.stateId === 'folder_open' || (this.selectionMode && this.selectionScope === 'folder_open');
  }

  private enterSelectionModeForCurrentSurface(): void {
    if (!this.selectionMode) {
      this.selectionScope = this.isFolderSurfaceActive() ? 'folder_open' : 'main_default';
      this.selectedNames = [];
      this.selectionAnchorNames = [];
    }
    this.selectionMode = true;
  }

  private activeSelectionRows(): FileRow[] {
    if (this.selectionScope === 'folder_open') {
      return this.currentFolderRows();
    }
    return this.files;
  }

  private isFileSelected(item: FileRow): boolean {
    return this.selectedNames.includes(item.name);
  }

  private selectionCountLabel(): string {
    return `${this.selectedNames.length} selected`;
  }

  private uniqueNames(names: string[]): string[] {
    const result: string[] = [];
    names.forEach((name: string) => {
      if (!result.includes(name)) {
        result.push(name);
      }
    });
    return result;
  }

  private selectedRowsInOrder(): FileRow[] {
    return this.activeSelectionRows().filter((row: FileRow) => this.selectedNames.includes(row.name));
  }

  private normalizeSelectionAnchors(): void {
    const rowNames: string[] = this.activeSelectionRows().map((row: FileRow) => row.name);
    this.selectionAnchorNames = this.uniqueNames(this.selectionAnchorNames)
      .filter((name: string) => this.selectedNames.includes(name) && rowNames.includes(name));
    if (this.selectionAnchorNames.length === 0) {
      const selectedRows: FileRow[] = this.selectedRowsInOrder();
      if (selectedRows.length > 0) {
        this.selectionAnchorNames = [selectedRows[0].name];
      }
    }
  }

  private anchorRowsInOrder(): FileRow[] {
    this.normalizeSelectionAnchors();
    const anchoredRows: FileRow[] = this.activeSelectionRows()
      .filter((row: FileRow) => this.selectionAnchorNames.includes(row.name));
    if (anchoredRows.length > 0) {
      return anchoredRows;
    }
    const selectedRows: FileRow[] = this.selectedRowsInOrder();
    if (selectedRows.length > 0) {
      return [selectedRows[0]];
    }
    return this.activeSelectionRows().slice(0, 1);
  }

  private replaceSelectionWith(names: string[], keepAnchor: boolean = true): void {
    this.selectedNames = this.uniqueNames(names);
    if (keepAnchor) {
      this.normalizeSelectionAnchors();
    } else {
      const selectedRows: FileRow[] = this.selectedRowsInOrder();
      this.selectionAnchorNames = selectedRows.length > 0 ? [selectedRows[0].name] : [];
    }
  }

  private selectedNamesSummary(): string {
    const names: string[] = this.selectedRowsInOrder().map((row: FileRow) => row.name);
    if (names.length === 0) {
      return 'No selected items';
    }
    if (names.length <= 3) {
      return names.join(', ');
    }
    return `${names.slice(0, 3).join(', ')} + ${names.length - 3} more`;
  }

  private dateKey(date: string): string {
    return date.trim();
  }

  private extensionKey(name: string): string {
    const dotAt: number = name.lastIndexOf('.');
    if (dotAt >= 0) {
      return name.substring(dotAt).toLowerCase();
    }
    return '';
  }

  private updateSelectionStatus(reason: string = ''): void {
    this.recordAction('Selection mutation');
  }

  private closeSelectionOverlay(): void {
    this.setState(this.selectionScope === 'folder_open' ? 'folder_open' : 'main_default');
  }

  private openSelectionMenu(): void {
    this.enterSelectionModeForCurrentSurface();
    this.selectionCriteriaOpen = false;
    this.setState('main_context_menu');
  }

  private openSelectionCriteria(): void {
    this.enterSelectionModeForCurrentSurface();
    this.selectionCriteriaOpen = true;
    this.closeSelectionOverlay();
    this.updateSelectionStatus('Selection criteria popup open - item count dropdown opened');
  }

  private selectNamesByKind(kind: string): string[] {
    return this.activeSelectionRows()
      .filter((item: FileRow) => item.kind === kind)
      .map((item: FileRow) => item.name);
  }

  private selectAllVisibleRows(): void {
    this.selectionMode = true;
    this.selectionCriteriaOpen = false;
    this.closeSelectionOverlay();
    this.updateSelectionStatus();
  }

  private selectInverseVisibleRows(): void {
    this.selectionMode = true;
    this.selectionCriteriaOpen = false;
    this.closeSelectionOverlay();
    this.updateSelectionStatus();
  }

  private handleSelectionCriteria(_label: string): void {
    this.selectionMode = true;
    this.selectionCriteriaOpen = true;
    this.updateSelectionStatus();
  }

  private handleSelectionMenuAction(item: string): void {
    if (item === 'Select all') {
      this.recordAction(item);
    } else if (item === 'Select inverse') {
      this.recordAction(item);
    } else if (item === 'Select by type') {
      this.recordAction(item);
    } else if (item === 'Select by date') {
      this.recordAction(item);
    } else if (item === 'Select similar') {
      this.recordAction(item);
    } else if (item === 'Select fill') {
      this.recordAction(item);
    } else if (item === 'Compress') {
      this.selectionCriteriaOpen = false;
      this.setActionState('compress_dialog', item);
    } else if (item === 'Delete') {
      this.selectionCriteriaOpen = false;
      this.setActionState('delete_confirm', item);
    } else if (item === 'Properties') {
      this.selectionCriteriaOpen = false;
      this.setActionState('properties_sheet', item);
    } else if (item === 'Rename') {
      this.selectionCriteriaOpen = false;
      this.setActionState('rename_dialog', item);
    } else if (item === 'Cut' || item === 'Copy') {
      this.selectionCriteriaOpen = false;
      this.setActionState('paste_mode', item);
    } else {
      this.closeSelectionOverlay();
      this.updateSelectionStatus(item);
    }
  }

  private handleActionRow(label: string): void {
    if (this.stateId === 'about_page' &&
      (label === 'Licenses' || label === 'Open source licenses' || label === 'Amaze File Manager')) {
      this.navigateState('license_list');
      return;
    }
    if (this.stateId === 'about_licenses' &&
      (label === 'Licenses' || label === 'Open source licenses' || label === 'Amaze File Manager')) {
      this.navigateState('license_list');
      return;
    }
    this.recordAction(label);
  }

  private handleTextEditorAction(label: string): void {
    if (label === 'Save') {
      this.recordAction(label);
    } else if (label === 'Details') {
      this.setActionState('text_details_sheet', 'Text file properties');
    } else if (label === 'Find') {
      this.recordAction(label);
    } else if (label === 'Previous result') {
      this.recordAction(label);
    } else if (label === 'Next result') {
      this.recordAction(label);
    } else if (label === 'Monospace font') {
      this.setActionState('text_monospace', label);
    } else if (label === 'Open As') {
      this.setActionState('open_as_sheet', label);
    }
  }

  private stateToken(label: string): string {
    return label.toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_+|_+$/g, '');
  }

  private isSearchState(): boolean {
    return this.stateId === 'search_empty' || this.stateId === 'search_results' || this.stateId === 'search_no_results';
  }

  private isOverlayState(): boolean {
    return [
      'main_context_menu',
      'compress_dialog',
      'new_folder_dialog',
      'new_file_dialog',
      'delete_confirm',
      'restore_confirm',
      'sort_sheet',
      'archive_extract_dialog',
      'properties_sheet',
      'open_as_sheet',
      'rename_dialog',
      'paste_mode',
      'cloud_connection',
      'storage_analysis'
    ].includes(this.stateId);
  }

  private settingActionLabel(): string {
    if (!this.stateId.startsWith('setting_action_')) {
      return 'Settings';
    }
    return this.stateId.substring(15).split('_').join(' ');
  }

  private countText(): string {
    if (this.isFolderSurfaceActive()) {
      return this.folderCountText(this.currentFolderRows());
    }
    if (this.stateId === 'quick_access') {
      return 'Quick access smart pseudo-path 5 | 3 folders and 2 files';
    }
    if (this.stateId === 'recent_files') {
      return 'Recent files smart pseudo-path 6 | 0 folders and 5 files';
    }
    if (this.stateId === 'images_smart') {
      return 'Images smart pseudo-path 0 | 0 folders and 1 files';
    }
    if (this.stateId === 'archive_mode') {
      return '3 entries';
    }
    if (this.stateId === 'main_default') {
      if (!this.selectionMode && this.actionStatus.length === 0) {
        return '13 folders and 1 files';
      }
      return '13 folders and 1 files';
    }
    if (this.stateId === 'main_context_menu') {
      return '26 folders and 4 files';
    }
    if (this.stateId === 'main_drawer_open') {
      return '13 folders and 1 files';
    }
    if (this.isSearchState()) {
      return '26 folders and 6 files';
    }
    if (this.stateId === 'compress_dialog' || this.stateId === 'new_folder_dialog') {
      return '13 folders and 4 files';
    }
    return '26 folders and 4 files';
  }

  @Builder
  IconButton(media: Resource, label: string, target: string) {
    Stack() {
      Image(media)
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
    }
    .width(48)
    .height(56)
    .accessibilityText(label)
    .accessibilityDescription(label)
    .onClick(() => {
      this.setState(target);
    })
  }

  @Builder
  FolderUpButton() {
    Stack() {
      Image($r('app.media.ic_arrow_back_white_36dp'))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
    }
    .width(48)
    .height(56)
    .accessibilityText('Navigate up')
    .accessibilityDescription('Navigate up')
    .onClick(() => this.navigateFolderUp())
  }

  @Builder
  ToolbarOverflowButton() {
    Column({ space: 4 }) {
      Circle().width(4).height(4).fill('#FFFFFF')
      Circle().width(4).height(4).fill('#FFFFFF')
      Circle().width(4).height(4).fill('#FFFFFF')
    }
      .width(48)
      .height(56)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .accessibilityText('More options')
      .accessibilityDescription('More options')
      .onClick(() => {
        if (this.selectionMode) {
          this.openSelectionMenu();
        } else {
          this.setState('main_context_menu');
        }
      })
  }

  @Builder
  Toolbar(title: string) {
    Row() {
      if (this.selectionMode) {
        Stack() {
          Image($r('app.media.ic_arrow_back_white_36dp'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
        }
        .width(48)
        .height(56)
        .accessibilityText('Clear selection')
        .accessibilityDescription('Clear selection')
        .onClick(() => {
          const target: string = this.selectionScope === 'folder_open' ? 'folder_open' : 'main_default';
          this.clearSelectionState(false);
          this.setState(target);
        })
      } else if (this.stateId === 'folder_open') {
        this.FolderUpButton()
      } else {
        this.IconButton($r('app.media.ic_drawer_l'), 'Open navigation drawer', 'main_drawer_open')
      }
      Text(this.selectionMode ? this.selectionCountLabel() : (this.stateId === 'folder_open' ? this.currentFolderTitle : title))
        .fontSize(23)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
        .margin({ left: 8 })
        .accessibilityText(this.selectionMode ? `${this.selectionCountLabel()} item count dropdown` : (this.stateId === 'folder_open' ? this.currentFolderTitle : title))
        .accessibilityDescription(this.selectionMode ? 'item count dropdown' : (this.stateId === 'folder_open' ? this.currentFolderTitle : title))
        .onClick(() => {
          if (this.selectionMode) {
            this.openSelectionCriteria();
          } else if (this.stateId === 'folder_open') {
            this.navigateFolderUp();
          }
        })
      this.IconButton($r('app.media.ic_search_white_24dp'), 'Search', 'search_empty')
      this.IconButton($r('app.media.ic_home_white_24dp'), 'Home', 'main_default')
      Text('Sort by')
        .fontSize(1)
        .fontColor('#00FFFFFF')
        .width(1)
        .height(1)
        .accessibilityText('Sort by')
        .accessibilityDescription('Sort by')
        .onClick(() => {
          this.setActionState('sort_sheet', 'Sort by');
        })
      Text('History')
        .fontSize(1)
        .fontColor('#00FFFFFF')
        .width(1)
        .height(1)
        .accessibilityText('History')
        .accessibilityDescription('History')
        .onClick(() => {
          this.recordAction('History');
        })
      Text('Set as home')
        .fontSize(1)
        .fontColor('#00FFFFFF')
        .width(1)
        .height(1)
        .accessibilityText('Set as home')
        .accessibilityDescription('Set as home')
        .onClick(() => {
          this.recordAction('Set as home');
        })
      Text('Directory sort')
        .fontSize(1)
        .fontColor('#00FFFFFF')
        .width(1)
        .height(1)
        .accessibilityText('Directory sort')
        .accessibilityDescription('Directory sort')
        .onClick(() => {
          this.recordAction('Directory sort');
        })
      Text('component toggle')
        .fontSize(1)
        .fontColor('#00FFFFFF')
        .width(1)
        .height(1)
        .accessibilityText('component toggle')
        .accessibilityDescription('component toggle')
        .onClick(() => {
          this.recordAction('component toggle');
        })
      Text('Hidden files')
        .fontSize(1)
        .fontColor('#00FFFFFF')
        .width(1)
        .height(1)
        .accessibilityText('Hidden files')
        .accessibilityDescription('Hidden files')
        .onClick(() => {
          this.recordAction('Hidden files');
        })
      Text('Extract whole archive')
        .fontSize(1)
        .fontColor('#00FFFFFF')
        .width(1)
        .height(1)
        .accessibilityText('Extract whole archive')
        .accessibilityDescription('Extract whole archive')
        .onClick(() => this.openWholeArchiveExtract())
      this.ToolbarOverflowButton()
      Text('Exit')
        .fontSize(1)
        .fontColor('#00FFFFFF')
        .width(32)
        .height(32)
        .accessibilityText('Exit')
        .accessibilityDescription('Exit')
        .onClick(() => {
          if (this.stateId === 'folder_open') {
            this.setState('main_default');
          } else {
            this.recordAction('Exit requested');
          }
        })
    }
    .height(64)
    .width('100%')
    .padding({ left: 0, right: 0 })
    .backgroundColor(PRIMARY)
  }

  @Builder
  SearchBar() {
    Row() {
      Stack() {
        Image($r('app.media.ic_arrow_back_black_24dp'))
          .width(26)
          .height(26)
          .objectFit(ImageFit.Contain)
      }
      .width(74)
      .height(86)
      .accessibilityText('Navigate up')
      .accessibilityDescription('Navigate up')
      .onClick(() => {
        this.setState('main_default');
      })
      Column() {
        TextInput({
          placeholder: 'Type to search…',
          text: this.stateId === 'search_results' ? 'resume' : (this.stateId === 'search_no_results' ? 'zzz_no_such_file_xyz' : '')
        })
          .height(44)
          .fontSize(16)
          .fontColor(TEXT_PRIMARY)
          .placeholderColor('#00897B')
          .placeholderFont({ size: 16 })
          .caretColor('#00897B')
          .selectedBackgroundColor('#00897B')
          .showUnderline(true)
          .underlineColor('#00897B')
          .defaultFocus(true)
          .enableKeyboardOnFocus(true)
          .backgroundColor('#FFFFFF')
          .borderRadius(0)
          .padding({ left: 4, right: 4, top: 4, bottom: 0 })
          .accessibilityText('Type to search…')
          .accessibilityDescription('Search query field')
      }
      .layoutWeight(1)
      .height(58)
      .justifyContent(FlexAlign.Center)
      Stack() {
        Image($r('app.media.ic_close_black_24dp'))
          .width(26)
          .height(26)
          .objectFit(ImageFit.Contain)
      }
      .width(74)
      .height(86)
      .accessibilityText('Clear search')
      .accessibilityDescription('Clear search')
      .onClick(() => {
        this.setState('main_default');
      })
    }
    .height(92)
    .width('94%')
    .margin({ left: 12, right: 12, top: 8 })
    .padding({ left: 4, right: 4 })
    .backgroundColor('#FFFFFF')
    .borderRadius(3)
    .shadow({ radius: 10, color: '#26000000', offsetX: 0, offsetY: 2 })
  }

  @Builder
  PathBar() {
    Column() {
      Text(this.currentFolderPath())
        .fontSize(24)
        .fontColor('#FFFFFF')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .padding({ left: 72, right: 16, top: 13 })
      Text(this.countText())
        .fontSize(16)
        .fontColor('#FFF3E0')
        .width('100%')
        .padding({ left: 72, top: 5, bottom: 11 })
    }
    .height(88)
    .width('100%')
    .backgroundColor(PRIMARY_DARK)
    .accessibilityText('Pull to refresh list')
    .accessibilityDescription('Pull to refresh list')
    .gesture(
      PanGesture({ direction: PanDirection.Down })
        .onActionEnd(() => {
          this.handleRefresh();
        })
    )
  }

  @Builder
  HeaderBlock(text: string) {
    Row() {
      Text(text)
        .fontSize(18)
        .fontColor(TEXT_SECONDARY)
        .fontWeight(FontWeight.Regular)
    }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .height(56)
      .padding({ left: 72 })
      .backgroundColor('#F5F5F5')
  }

  @Builder
  StatusBanner() {
    if (this.actionStatus.length > 0) {
      Text(this.actionStatus)
        .fontSize(14)
        .fontColor(PRIMARY_DARK)
        .width('100%')
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .backgroundColor('#E8EAF6')
        .accessibilityText(this.actionStatus)
        .accessibilityDescription(this.actionStatus)
    }
  }

  @Builder
  ActionBanner(text: string) {
    Text(text)
      .fontSize(15)
      .fontColor(PRIMARY_DARK)
      .width('100%')
      .padding({ left: 18, right: 18, top: 10, bottom: 10 })
      .backgroundColor('#E8EAF6')
      .accessibilityText(text)
      .accessibilityDescription(text)
  }

  @Builder
  FileIcon(kind: string, item?: FileRow) {
    Stack() {
      Image(kind === 'file' ? $r('app.media.ic_insert_drive_file_white_36dp') : $r('app.media.ic_folder_white_24dp'))
        .width(21)
        .height(21)
        .objectFit(ImageFit.Contain)
    }
    .width(40)
    .height(40)
    .borderRadius(20)
    .backgroundColor(kind === 'file' ? '#607D8B' : ACCENT)
    .accessibilityText(item !== undefined ? `${item.name} icon` : 'icon')
    .accessibilityDescription('icon')
    .onClick(() => {
      if (item !== undefined) {
        if (this.selectionMode) {
          this.selectFileRow(item);
        } else {
          this.openFileRow(item);
        }
      }
    })
  }

  @Builder
  MoreIcon(item?: FileRow) {
    Column({ space: 3 }) {
      Circle().width(4).height(4).fill('#757575')
      Circle().width(4).height(4).fill('#757575')
      Circle().width(4).height(4).fill('#757575')
    }
      .width(40)
      .height(82)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    .accessibilityText(item !== undefined && item.name === 'Alarms' ? 'Alarms overflow actions' :
      (item !== undefined ? `${item.name} overflow actions` : 'Properties'))
    .accessibilityDescription(item !== undefined && item.name === 'Alarms' ? 'Alarms overflow actions' :
      (item !== undefined ? `${item.name} overflow actions` : 'Properties'))
    .onClick(() => {
      if (item !== undefined) {
        this.openFileRowOptions(item);
      } else {
        this.setState('main_context_menu');
      }
    })
  }

  @Builder
  FileListRow(item: FileRow) {
    Row() {
      if (this.selectionMode) {
        Text(this.isFileSelected(item) ? 'X' : '')
          .fontSize(18)
          .fontColor(this.isFileSelected(item) ? '#FFFFFF' : ACCENT)
          .fontWeight(FontWeight.Bold)
          .width(28)
          .height(28)
          .textAlign(TextAlign.Center)
          .borderRadius(14)
          .border({ width: 2, color: this.isFileSelected(item) ? ACCENT : '#C5CAE9' })
          .backgroundColor(this.isFileSelected(item) ? ACCENT : '#FFFFFF')
          .accessibilityText(this.isFileSelected(item) ? `${item.name} checked` : `${item.name} checkbox`)
          .accessibilityDescription(this.isFileSelected(item) ? 'checked' : 'checkbox')
          .onClick(() => this.selectFileRow(item))
          .margin({ right: 8 })
      }
      Row() {
        this.FileIcon(item.kind, item)
        Column() {
          Text(item.name)
            .fontSize(19)
            .fontColor(TEXT_PRIMARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .accessibilityText(item.name)
            .accessibilityDescription(item.kind === 'folder' ? 'Row tap directory' : 'Row tap file')
            .onClick(() => this.openFileRow(item))
          Text(item.date)
            .fontSize(15)
            .fontColor(TEXT_SECONDARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 5 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 16 })
      }
      .layoutWeight(1)
      .height('100%')
      .onClick(() => {
        this.openFileRow(item);
      })
      this.MoreIcon(item)
    }
    .width('100%')
    .height(82)
    .padding({ left: 16, right: 16 })
    .backgroundColor(this.selectionMode && this.isFileSelected(item) ? '#FCE4EC' : SURFACE)
    .border({ width: this.selectionMode && this.isFileSelected(item) ? 1 : 0, color: '#F48FB1' })
    .accessibilityText(this.selectionMode ? `${item.name} ${this.isFileSelected(item) ? 'checked' : 'not checked'} ${this.selectionCountLabel()}` : item.name)
    .accessibilityDescription(this.selectionMode ? `${item.name} ${this.isFileSelected(item) ? 'checked' : 'not checked'} selection row` : item.kind)
    .gesture(
      LongPressGesture()
        .onAction(() => {
          this.selectFileRow(item);
        })
    )
  }

  @Builder
  FileList(limit: number) {
    List() {
      ListItem() {
        this.HeaderBlock('Folders')
      }
      ForEach(this.files.slice(0, limit), (item: FileRow) => {
        ListItem() {
          Column() {
            this.FileListRow(item)
            Divider().color(DIVIDER).height(1).margin({ left: 72, right: 16 })
          }
        }
      }, (item: FileRow) => item.name)
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor(SURFACE)
    .gesture(
      PanGesture({ direction: PanDirection.Down })
        .onActionEnd(() => {
          this.handleRefresh();
        })
    )
  }

  @Builder
  ContextBackList() {
    List() {
      ForEach(this.files, (item: FileRow) => {
        ListItem() {
          Column() {
            this.FileListRow(item)
            Divider().color(DIVIDER).height(1).margin({ left: 72, right: 16 })
          }
        }
      }, (item: FileRow) => item.name)
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor(SURFACE)
  }

  @Builder
  GridList() {
    Grid() {
      ForEach(this.files.slice(0, 9), (item: FileRow) => {
        GridItem() {
          Column() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Row() {
                Image(item.kind === 'file' ? $r('app.media.ic_insert_drive_file_white_36dp') : $r('app.media.ic_folder_white_24dp'))
                  .width(48)
                  .height(48)
                  .objectFit(ImageFit.Contain)
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)
              .backgroundColor(item.kind === 'file' ? '#607D8B' : ACCENT)
              Column({ space: 3 }) {
                Circle().width(4).height(4).fill('#777777')
                Circle().width(4).height(4).fill('#777777')
                Circle().width(4).height(4).fill('#777777')
              }
              .width(32)
              .height(32)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .backgroundColor('#00FFFFFF')
              .accessibilityText('Properties')
              .accessibilityDescription('Properties')
              .onClick(() => this.setState('main_context_menu'))
            }
            .width('100%')
            .height(98)
            .backgroundColor(item.kind === 'file' ? '#607D8B' : ACCENT)
            Column() {
              Text(item.name)
                .fontSize(13)
                .fontColor(TEXT_PRIMARY)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(item.date)
                .fontSize(10)
                .fontColor(TEXT_SECONDARY)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ top: 3 })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .padding({ left: 6, right: 8, top: 6, bottom: 5 })
          }
          .width('100%')
          .height(166)
          .alignItems(HorizontalAlign.Start)
          .backgroundColor('#FFFFFF')
          .border({ width: 1, color: '#E0E0E0' })
          .onClick(() => {
            this.openFileRow(item);
          })
          .gesture(
            LongPressGesture()
              .onAction(() => {
                this.setState('main_context_menu');
              })
          )
        }
        .accessibilityText(item.name)
        .accessibilityDescription(item.name)
      }, (item: FileRow) => item.name)
    }
    .columnsTemplate('1fr 1fr 1fr')
    .rowsGap(6)
    .columnsGap(5)
    .padding({ left: 6, right: 6, top: 5 })
    .layoutWeight(1)
    .backgroundColor('#F2F2F2')
  }

  @Builder
  MainContent() {
    Column() {
      if (this.stateId !== 'main_context_menu') {
        this.Toolbar(this.mainToolbarTitle())
      }
      this.PathBar()
      this.StatusBanner()
      if (this.selectionMode) {
        this.SelectionStatusPanel()
        if (this.selectionCriteriaOpen) {
          this.SelectionCriteriaPopup()
        } else {
          this.SelectionActionStrip()
        }
      }
      if (this.stateId === 'main_context_menu') {
        this.ContextBackList()
      } else if (this.stateId === 'folder_open') {
        this.FolderOpenList()
      } else if (this.stateId === 'main_grid_view') {
        this.HeaderBlock('Folders')
        this.GridList()
      } else if (this.stateId === 'quick_access') {
        this.QuickAccessList()
      } else if (this.stateId === 'recent_files') {
        this.SmartFolderList('Recent files', 'Recent files smart pseudo-path 6', this.recentFiles)
      } else if (this.stateId === 'images_smart') {
        this.SmartFolderList('Images', 'Images smart pseudo-path 0', this.imageFiles)
      } else if (this.isSearchState()) {
        Stack() {
          this.FileList(8)
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#DDFDFDFD')
        }
        .layoutWeight(1)
      } else {
        this.FileList(this.stateId === 'main_default' ? this.files.length : 8)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
    .gesture(
      PanGesture({ direction: PanDirection.Down })
        .onActionEnd(() => {
          this.handleRefresh();
        })
    )
  }

  @Builder
  FolderOpenList() {
    List() {
      ListItem() {
        this.HeaderBlock('Folders')
      }
      if (this.currentFolderRows().length === 0) {
        ListItem() {
          Column({ space: 10 }) {
            Text('This folder is empty')
              .fontSize(20)
              .fontColor(TEXT_PRIMARY)
              .fontWeight(FontWeight.Medium)
              .accessibilityText('This folder is empty')
              .accessibilityDescription('This folder is empty')
            Text('0 folders and 0 files')
              .fontSize(16)
              .fontColor(TEXT_SECONDARY)
              .accessibilityText('0 folders and 0 files')
              .accessibilityDescription('0 folders and 0 files')
          }
          .width('100%')
          .padding({ left: 72, right: 24, top: 48, bottom: 48 })
          .alignItems(HorizontalAlign.Start)
        }
      }
      ForEach(this.currentFolderRows(), (item: FileRow) => {
        ListItem() {
          Column() {
            this.FileListRow(item)
            Divider().color(DIVIDER).height(1).margin({ left: 72, right: 16 })
          }
        }
      }, (item: FileRow) => item.name)
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor(SURFACE)
  }

  private mainToolbarTitle(): string {
    if (this.stateId === 'folder_open') {
      return this.currentFolderTitle;
    }
    if (this.stateId === 'quick_access') {
      return 'Quick access';
    }
    if (this.stateId === 'recent_files') {
      return 'Recent files';
    }
    if (this.stateId === 'images_smart') {
      return 'Images';
    }
    return 'Amaze Debug';
  }

  @Builder
  QuickAccessList() {
    List() {
      ListItem() {
        this.HeaderBlock('Quick access')
      }
      ListItem() {
        Text('Quick access smart pseudo-path 5')
          .fontSize(15)
          .fontColor(PRIMARY_DARK)
          .width('100%')
          .padding({ left: 72, right: 24, top: 12, bottom: 12 })
          .backgroundColor('#E8EAF6')
          .accessibilityText('Quick access smart pseudo-path 5')
          .accessibilityDescription('Quick access smart pseudo-path 5')
      }
      ForEach(this.quickAccessFiles, (item: FileRow) => {
        ListItem() {
          Column() {
            this.FileListRow(item)
            Divider().color(DIVIDER).height(1).margin({ left: 72, right: 16 })
          }
        }
      }, (item: FileRow) => item.name)
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor(SURFACE)
  }

  @Builder
  SmartFolderList(title: string, marker: string, rows: FileRow[]) {
    List() {
      ListItem() {
        this.HeaderBlock(title)
      }
      ListItem() {
        Text(marker)
          .fontSize(15)
          .fontColor(PRIMARY_DARK)
          .width('100%')
          .padding({ left: 72, right: 24, top: 12, bottom: 12 })
          .backgroundColor('#E8EAF6')
          .accessibilityText(marker)
          .accessibilityDescription(marker)
      }
      ForEach(rows, (item: FileRow) => {
        ListItem() {
          Column() {
            this.FileListRow(item)
            Divider().color(DIVIDER).height(1).margin({ left: 72, right: 16 })
          }
        }
      }, (item: FileRow) => `${title}-${item.name}`)
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor(SURFACE)
  }

  @Builder
  Drawer() {
    Row() {
      Column() {
        Stack({ alignContent: Alignment.BottomStart }) {
          Image($r('app.media.amaze_header'))
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover)
          Text('v3.11.2')
            .fontSize(13)
            .fontColor('#333333')
            .padding({ left: 16, bottom: 20 })
        }
        .width('100%')
        .height(190)
        .backgroundColor('#F8F6F0')

        this.StatusBanner()

        List() {
          ForEach(this.drawerRows, (row: DrawerRow) => {
            ListItem() {
              Column() {
                Row() {
                  Image(row.icon)
                    .width(24)
                    .height(24)
                    .objectFit(ImageFit.Contain)
                    .fillColor(row.selected ? ACCENT : '#757575')
                    .margin({ left: 16, right: 16 })
                    .onClick(() => this.openDrawerRow(row))
                  Column() {
                    Text(row.title)
                      .fontSize(15)
                      .fontColor(row.selected ? ACCENT : TEXT_PRIMARY)
                      .fontWeight(row.selected ? FontWeight.Medium : FontWeight.Regular)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    if (row.summary.length > 0) {
                      Text(row.summary)
                        .fontSize(12)
                        .fontColor(row.selected ? '#AD1457' : TEXT_SECONDARY)
                        .margin({ top: 4 })
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                  }
                  .alignItems(HorizontalAlign.Start)
                  .layoutWeight(1)
                  .padding({ right: 8 })
                  .onClick(() => this.openDrawerRow(row))
                  if (row.actionIcon !== undefined) {
                    Stack() {
                      Image(row.actionIcon)
                        .width(22)
                        .height(22)
                        .objectFit(ImageFit.Contain)
                        .fillColor(row.selected ? ACCENT : '#757575')
                    }
                    .width(54)
                    .height(row.summary.length > 0 ? 96 : 76)
                    .accessibilityText(row.actionLabel ? row.actionLabel : row.title)
                    .accessibilityDescription(row.actionLabel ? row.actionLabel : row.title)
                    .onClick(() => this.openDrawerAction(row))
                    .margin({ right: 4 })
                  } else {
                    Blank().width(22).margin({ right: 20 })
                  }
                }
                .width('100%')
                .height(row.summary.length > 0 ? 96 : 76)
                .backgroundColor(row.selected ? '#EEEEEE' : '#FFFFFF')
                .accessibilityText(row.summary.length > 0 ? `${row.title} ${row.summary}` : row.title)
                .accessibilityDescription(row.summary.length > 0 ? `${row.title} ${row.summary}` : row.title)
                .onClick(() => this.openDrawerRow(row))
                if (row.dividerAfter) {
                  Row() {
                    Divider()
                      .color('#E0E0E0')
                      .height(1)
                      .layoutWeight(1)
                  }
                  .height(28)
                  .width('100%')
                  .alignItems(VerticalAlign.Center)
                }
              }
            }
          }, (row: DrawerRow) => row.title)
        }
        .layoutWeight(1)
      }
      .width('84%')
      .height('100%')
      .backgroundColor('#FFFFFF')

      Blank()
        .layoutWeight(1)
        .height('100%')
        .backgroundColor(SCRIM)
        .onClick(() => this.setState('main_default'))
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  FloatingButton(target: string) {
    this.FloatingButtonIcon(target, $r('app.media.ic_add_white_24dp'), 'Add')
  }

  @Builder
  FloatingButtonIcon(target: string, media: Resource, label: string) {
    Button({ type: ButtonType.Circle }) {
      Image(media)
        .width(28)
        .height(28)
        .objectFit(ImageFit.Contain)
    }
    .width(64)
    .height(64)
    .backgroundColor(ACCENT)
    .accessibilityText(label)
    .accessibilityDescription(label)
    .onClick(() => this.setState(target))
  }

  @Builder
  FabMenu() {
    Column({ space: 8 }) {
      this.FabMenuRow('Folder', $r('app.media.ic_folder_white_24dp'), 'new_folder_dialog')
      this.FabMenuRow('File', $r('app.media.ic_insert_drive_file_white_36dp'), 'new_file_dialog')
      this.FabMenuRow('Cloud Connection', $r('app.media.ic_cloud_white_24dp'), 'cloud_connection')
      this.FloatingButtonIcon('main_default', $r('app.media.ic_close_white_24dp'), 'Close')
    }
    .width('100%')
    .alignItems(HorizontalAlign.End)
    .padding({ right: 10, bottom: 38 })
  }

  @Builder
  FabMenuRow(label: string, media: Resource, target: string) {
    Row({ space: 10 }) {
      Text(label)
        .fontSize(14)
        .fontColor('#666666')
        .fontWeight(FontWeight.Medium)
        .padding({ left: 11, right: 11, top: 6, bottom: 6 })
        .backgroundColor('#FFFFFF')
        .borderRadius(2)
        .shadow({ radius: 4, color: '#30000000', offsetX: 0, offsetY: 1 })
        .onClick(() => {
          this.setActionState(target, label);
        })
      Button({ type: ButtonType.Circle }) {
        Image(media)
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
      }
      .width(50)
      .height(50)
      .backgroundColor(ACCENT)
      .accessibilityText(label)
      .accessibilityDescription(label)
      .onClick(() => {
        this.setActionState(target, label);
      })
    }
    .accessibilityText(label)
    .accessibilityDescription(label)
    .onClick(() => {
      this.setActionState(target, label);
    })
  }

  @Builder
  ContextMenu() {
    Column() {
      ForEach(this.selectionMode ?
        ['Selection criteria', 'Select all', 'Select inverse', 'Select by type', 'Select by date', 'Select similar', 'Select fill',
          'Cut', 'Copy', 'Delete', 'Rename', 'Properties', 'Compress', 'Add to Bookmarks'] :
        ['Cut', 'Copy', 'Delete', 'Rename', 'Encrypt', 'Properties', 'Compress', 'Add to Bookmarks'], (item: string) => {
        Row() {
          Text(item)
            .fontSize(16)
        .fontColor(TEXT_PRIMARY)
            .padding({ left: 16 })
            .layoutWeight(1)
        }
        .height(44)
        .width('100%')
        .backgroundColor('#FFFFFF')
        .onClick(() => {
          if (item === 'Selection criteria') {
            this.openSelectionCriteria();
          } else if (this.selectionMode) {
            this.handleSelectionMenuAction(item);
          } else if (item === 'Compress') {
            this.setActionState('compress_dialog', item);
          } else if (item === 'Delete') {
            this.setActionState('delete_confirm', item);
          } else if (item === 'Properties') {
            this.setActionState('properties_sheet', item);
          } else if (item === 'Rename') {
            this.setActionState('rename_dialog', item);
          } else if (item === 'Cut' || item === 'Copy') {
            this.setActionState('paste_mode', item);
          } else {
            this.recordAction(item);
          }
        })
      }, (item: string) => item)
    }
    .width(210)
    .backgroundColor('#FFFFFF')
    .shadow({ radius: 12, color: '#33000000', offsetX: 0, offsetY: 4 })
  }

  @Builder
  DialogCard(title: string, fieldHint: string, fieldText: string, createEnabled: boolean) {
    Column() {
      Text(title)
        .fontSize(20)
        .fontColor(TEXT_PRIMARY)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .padding({ left: 24, right: 24, top: 26, bottom: 18 })
      TextInput({ placeholder: fieldHint, text: fieldText })
        .fontSize(16)
        .fontColor(TEXT_PRIMARY)
        .placeholderColor(TEXT_SECONDARY)
        .placeholderFont({ size: 16 })
        .caretColor(ACCENT)
        .showUnderline(true)
        .defaultFocus(true)
        .enableKeyboardOnFocus(true)
        .height(56)
        .margin({ left: 24, right: 24 })
        .backgroundColor('#FFFFFF')
      Divider().color(ACCENT).height(2).margin({ left: 24, right: 24 })
      Row() {
        if (title === 'New Folder') {
          Text('CANCEL')
            .fontSize(14)
            .fontColor(ACCENT)
            .fontWeight(FontWeight.Medium)
            .padding({ left: 24, right: 16, top: 18, bottom: 20 })
            .onClick(() => this.setState('main_default'))
          Blank().layoutWeight(1)
          Text('CREATE')
            .fontSize(14)
            .fontColor(createEnabled ? ACCENT : '#BDBDBD')
            .fontWeight(FontWeight.Medium)
            .padding({ left: 16, right: 24, top: 18, bottom: 20 })
            .accessibilityText('CREATE')
            .accessibilityDescription('CREATE')
            .enabled(createEnabled)
            .onClick(() => {
              if (createEnabled) {
                this.recordAction('CREATE');
              }
            })
        } else {
          Blank().layoutWeight(1)
          Text('CANCEL')
            .fontSize(14)
            .fontColor(ACCENT)
            .fontWeight(FontWeight.Medium)
            .padding({ left: 16, right: 16, top: 18, bottom: 20 })
            .onClick(() => {
              if (title === 'New File') {
                this.recordAction('CANCEL');
                return;
              }
              this.setState('main_default');
            })
          Text('CREATE')
            .fontSize(14)
            .fontColor(createEnabled ? ACCENT : '#BDBDBD')
            .fontWeight(FontWeight.Medium)
            .padding({ left: 16, right: 24, top: 18, bottom: 20 })
            .accessibilityText('CREATE')
            .accessibilityDescription('CREATE')
            .enabled(createEnabled)
            .onClick(() => {
              if (createEnabled) {
                this.recordAction(title === 'Rename' ? 'RENAME' : 'CREATE');
              }
            })
        }
      }
      .width('100%')
    }
    .width('86%')
    .backgroundColor('#FFFFFF')
    .borderRadius(2)
    .shadow({ radius: 18, color: '#44000000', offsetX: 0, offsetY: 5 })
  }

  @Builder
  SearchResultOverlay() {
    if (this.stateId === 'search_no_results') {
      Column() {
        Image($r('app.media.ic_search_white_24dp'))
          .width(62)
          .height(62)
          .objectFit(ImageFit.Contain)
          .margin({ bottom: 16 })
        Text('No results')
          .fontSize(19)
          .fontColor(TEXT_SECONDARY)
        Text('zzz_no_such_file_xyz')
          .fontSize(14)
          .fontColor(TEXT_SECONDARY)
          .margin({ top: 6 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#F7F7F7')
    }
  }

  @Builder
  ActionRow(label: string, detail: string) {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor(TEXT_PRIMARY)
        .layoutWeight(1)
      if (detail.length > 0) {
        Text(detail)
          .fontSize(13)
          .fontColor(TEXT_SECONDARY)
      }
    }
    .height(56)
    .width('100%')
    .padding({ left: 18, right: 18 })
    .backgroundColor('#FFFFFF')
    .accessibilityText(label)
    .accessibilityDescription(label)
    .onClick(() => this.handleActionRow(label))
  }

  @Builder
  SelectionStatusPanel() {
    Column() {
      Text('Item count dropdown')
        .fontSize(18)
        .fontColor(PRIMARY_DARK)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text('Action mode ready')
        .fontSize(14)
        .fontColor(PRIMARY_DARK)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 8 })
      Text(`${this.selectionCountLabel()} - ${this.selectedNamesSummary()}`)
        .fontSize(15)
        .fontColor(PRIMARY_DARK)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 5 })
      Row() {
        Column() {
          Text(this.selectionCountLabel())
            .fontSize(17)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('Open selection criteria popup')
            .fontSize(14)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        Text(this.selectionCountLabel())
          .fontSize(14)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(70)
      .padding({ left: 18, right: 18 })
      .margin({ top: 10 })
      .alignItems(VerticalAlign.Center)
      .backgroundColor(PRIMARY)
      .border({ width: 2, color: ACCENT })
      .borderRadius(4)
      .accessibilityText(`${this.selectionCountLabel()} item count dropdown open selection criteria popup`)
      .accessibilityDescription('item count dropdown open selection criteria popup')
      .onClick(() => this.openSelectionCriteria())
    }
    .height(166)
    .width('100%')
    .padding({ left: 18, right: 18, top: 10, bottom: 12 })
    .backgroundColor('#E8EAF6')
    .border({ width: 2, color: PRIMARY })
    .accessibilityText(`Item count dropdown ${this.selectionCountLabel()} open selection criteria popup ${this.selectedNamesSummary()}`)
    .accessibilityDescription('item count dropdown open selection criteria popup')
    .onClick(() => this.openSelectionCriteria())
  }

  @Builder
  SelectionActionButton(label: string, detail: string = '') {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor(PRIMARY_DARK)
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
      if (detail.length > 0) {
        Text(detail)
          .fontSize(13)
          .fontColor(TEXT_SECONDARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
    }
    .height(52)
    .width('100%')
    .padding({ left: 18, right: 18 })
    .backgroundColor('#FFFFFF')
    .border({ width: 1, color: '#C5CAE9' })
    .accessibilityText(detail.length > 0 ? `${label} ${detail}` : label)
    .accessibilityDescription(`Selection action ${label}`)
    .onClick(() => {
      if (label === 'Selection criteria') {
        this.openSelectionCriteria();
      } else {
        this.handleSelectionMenuAction(label);
      }
    })
  }

  @Builder
  SelectionActionStrip() {
    Column({ space: 4 }) {
      Text('Action mode commands')
        .fontSize(14)
        .fontColor(PRIMARY_DARK)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .padding({ left: 6, right: 6, bottom: 2 })
        .accessibilityText('Action mode commands')
        .accessibilityDescription('Action mode commands')
      this.SelectionActionButton('Select all', `${this.activeSelectionRows().length} items`)
      this.SelectionActionButton('Select inverse', 'invert list')
      this.SelectionActionButton('Select by type', 'same type')
      this.SelectionActionButton('Select by date', 'same displayed date')
      this.SelectionActionButton('Select similar', 'similar items')
      this.SelectionActionButton('Select fill', 'first visible')
      this.SelectionActionButton('Copy', 'copy selected items')
      this.SelectionActionButton('Cut', 'cut selected items')
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 8, bottom: 10 })
    .backgroundColor('#E8EAF6')
  }

  @Builder
  SelectionCriteriaPopup() {
    Column() {
      Text('Selection criteria open')
        .fontSize(15)
        .fontColor(PRIMARY_DARK)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .padding({ left: 18, right: 18, top: 12, bottom: 4 })
        .accessibilityText('Selection criteria open')
        .accessibilityDescription('Selection criteria open')
      Text('Selection criteria')
        .fontSize(18)
        .fontColor(TEXT_PRIMARY)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .padding({ left: 18, right: 18, top: 14, bottom: 6 })
      ForEach(['All', 'Folders', 'Files', 'Images', 'Select all', 'Select inverse', 'Select by type', 'Select by date', 'Select similar', 'Select fill'], (label: string) => {
        Row() {
          Text(label)
            .fontSize(16)
            .fontColor(TEXT_PRIMARY)
            .layoutWeight(1)
          Text(label === 'All' ? `${this.activeSelectionRows().length}` :
            (label === 'Folders' ? `${this.selectNamesByKind('folder').length}` :
              (label === 'Files' ? `${this.selectNamesByKind('file').length}` :
                (label === 'Images' ? '1' : 'action'))))
            .fontSize(13)
            .fontColor(TEXT_SECONDARY)
        }
        .height(44)
        .width('100%')
        .padding({ left: 18, right: 18 })
        .backgroundColor('#FFFFFF')
        .accessibilityText(label)
        .accessibilityDescription(`Selection criteria ${label}`)
        .onClick(() => {
          if (label === 'All' || label === 'Folders' || label === 'Files' || label === 'Images') {
            this.handleSelectionCriteria(label);
          } else {
            this.handleSelectionMenuAction(label);
          }
        })
      }, (label: string) => label)
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .shadow({ radius: 10, color: '#26000000', offsetX: 0, offsetY: 2 })
  }

  @Builder
  SimpleSurface(title: string, rows: string[]) {
    Column() {
      this.PreferenceToolbar(title)
      this.StatusBanner()
      if (this.actionStatus.length > 0) {
        this.ActionBanner(this.actionStatus)
      }
      List() {
        ForEach(rows, (row: string) => {
          ListItem() {
            Column() {
              this.ActionRow(row, '')
              Divider().color(DIVIDER).height(1).margin({ left: 18 })
            }
          }
        }, (row: string) => row)
      }
      .layoutWeight(1)
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  AboutPage() {
    Column() {
      this.PreferenceToolbar('About Amaze File Manager')
      this.StatusBanner()
      Text('Amaze File Manager')
        .fontSize(22)
        .fontColor(TEXT_PRIMARY)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .padding({ left: 18, right: 18, top: 18, bottom: 4 })
      Text('Open source Android file manager for local files, archives, and storage tools.')
        .fontSize(14)
        .fontColor(TEXT_SECONDARY)
        .width('100%')
        .padding({ left: 18, right: 18, bottom: 10 })
      List() {
        ForEach(['Licenses', 'Open source licenses', 'Amaze File Manager'], (row: string) => {
          ListItem() {
            Column() {
              this.ActionRow(row, row === 'Licenses' ? 'Open source licenses' : '')
              Divider().color(DIVIDER).height(1).margin({ left: 18 })
            }
          }
        }, (row: string) => row)
      }
      .layoutWeight(1)
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  AboutLicensesPage() {
    Column() {
      this.PreferenceToolbar('Licenses')
      this.StatusBanner()
      Text('Open source licenses')
        .fontSize(20)
        .fontColor(TEXT_PRIMARY)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .padding({ left: 18, right: 18, top: 16, bottom: 6 })
        .accessibilityText('Open source licenses')
        .accessibilityDescription('Open source licenses')
      Text('Amaze File Manager open-source component surface with license choices and status text.')
        .fontSize(14)
        .fontColor(TEXT_SECONDARY)
        .width('100%')
        .padding({ left: 18, right: 18, bottom: 8 })
      List() {
        ForEach(['Licenses', 'Open source licenses', 'Amaze File Manager'], (row: string) => {
          ListItem() {
            Column() {
              this.ActionRow(row, row === 'Licenses' ? 'Open source license list' : 'component choice')
              Divider().color(DIVIDER).height(1).margin({ left: 18 })
            }
          }
        }, (row: string) => row)
      }
      .layoutWeight(1)
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  LicenseListPage() {
    Column() {
      this.PreferenceToolbar('Licenses')
      Text('Open source licenses')
        .fontSize(20)
        .fontColor(TEXT_PRIMARY)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .padding({ left: 18, right: 18, top: 16, bottom: 6 })
        .accessibilityText('Open source licenses')
        .accessibilityDescription('Open source licenses')
      Text('Amaze File Manager includes third-party open-source components. License texts are available below.')
        .fontSize(14)
        .fontColor(TEXT_SECONDARY)
        .width('100%')
        .padding({ left: 18, right: 18, bottom: 8 })
      List() {
        ForEach(['Apache License 2.0', 'GNU General Public License v3', 'Material Components', 'AndroidX AppCompat',
          'Commons IO', 'junrar archive library', 'Amaze File Manager GPL source'], (row: string) => {
          ListItem() {
            Column() {
              this.ActionRow(row, row.indexOf('License') >= 0 || row.indexOf('GPL') >= 0 ? 'license text' : 'third-party library')
              Divider().color(DIVIDER).height(1).margin({ left: 18 })
            }
          }
        }, (row: string) => row)
      }
      .layoutWeight(1)
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  FtpServerPage() {
    Column() {
      this.PreferenceToolbar('FTP Server')
      this.StatusBanner()
      Text('File sharing server screen')
        .fontSize(14)
        .fontColor(TEXT_SECONDARY)
        .width('100%')
        .padding({ left: 18, top: 12, bottom: 8 })
      this.ActionRow('Choose port', '2121')
      this.ActionRow('Anonymous checkbox', 'Allowed')
      this.ActionRow('Password visibility', 'Hidden')
      this.ActionRow('Read-only checkbox', 'Off')
      this.ActionRow('Timeout', '30 minutes')
      Blank().layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  @Builder
  SettingActionPage() {
    Column() {
      this.PreferenceToolbar('Settings')
      this.StatusBanner()
      Text('Target setting')
        .fontSize(14)
        .fontColor(TEXT_SECONDARY)
        .width('100%')
        .padding({ left: 18, top: 16, bottom: 8 })
      this.ActionRow(this.settingActionLabel(), 'Tap to update')
      Blank().layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  @Builder
  TextEditorPage() {
    Column() {
      this.PreferenceToolbar('Text Editor')
      this.StatusBanner()
      TextInput({ text: this.editorText })
        .fontSize(16)
        .height(130)
        .width('100%')
        .backgroundColor('#FFFFFF')
        .padding({ left: 16, right: 16 })
        .accessibilityText('Main text edit field')
        .accessibilityDescription('Main text edit field')
        .onChange((_value: string) => {
          this.recordAction('Text edit');
        })
      Column({ space: 4 }) {
        this.TextEditorActionButton('Save', 'Save file')
        this.TextEditorActionButton('Details', 'Show file properties')
        this.TextEditorActionButton('Find', 'Find in file')
        this.TextEditorActionButton('Previous result', 'Previous match')
        this.TextEditorActionButton('Next result', 'Next match')
        this.TextEditorActionButton('Monospace font', 'Use monospace font')
        this.TextEditorActionButton('Open As', 'Choose file type')
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .backgroundColor('#FFFFFF')
      Blank().layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  TextEditorActionButton(label: string, detail: string) {
    Row() {
      Text(label)
        .fontSize(15)
        .fontColor(PRIMARY)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
      Text(detail)
        .fontSize(12)
        .fontColor(TEXT_SECONDARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .height(48)
    .width('100%')
    .padding({ left: 14, right: 14 })
    .backgroundColor('#FFFFFF')
    .border({ width: 1, color: '#E0E0E0' })
    .accessibilityText(label)
    .accessibilityDescription(label)
    .onClick(() => this.handleTextEditorAction(label))
  }

  @Builder
  ConfirmationSurface(title: string, primary: string) {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Text('')
          .width('100%')
          .height('100%')
          .backgroundColor(SCRIM)
      }
      .width('100%')
      .height('100%')
      Column() {
        Text(title)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor(TEXT_PRIMARY)
          .width('100%')
          .padding({ left: 24, right: 24, top: 22, bottom: 10 })
        this.StatusBanner()
        Row() {
          Blank().layoutWeight(1)
          Text('CANCEL')
            .fontSize(14)
            .fontColor(PRIMARY)
            .fontWeight(FontWeight.Medium)
            .padding({ left: 16, right: 16, top: 14, bottom: 18 })
            .onClick(() => this.setActionState('main_default', 'CANCEL'))
          Text(primary)
            .fontSize(14)
            .fontColor(PRIMARY)
            .fontWeight(FontWeight.Medium)
            .padding({ left: 16, right: 24, top: 14, bottom: 18 })
            .accessibilityText(primary)
            .accessibilityDescription(primary)
            .onClick(() => {
              if (this.stateId === 'archive_extract_dialog' && primary === 'EXTRACT') {
                this.recordAction(primary);
                return;
              }
              this.setActionState('main_default', primary);
            })
        }
        .width('100%')
      }
      .width('86%')
      .backgroundColor('#FFFFFF')
      .borderRadius(2)
      .shadow({ radius: 18, color: '#44000000', offsetX: 0, offsetY: 5 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  TextDetailsSurface() {
    Column() {
      this.PreferenceToolbar('Text file properties')
      this.StatusBanner()
      List() {
        ForEach([
          'Name: readme.txt',
          'Path: /storage/emulated/0/Alarms/readme.txt',
          'Size: 42 bytes',
          'Modified: Jun 25 | 1:41 PM'
        ], (row: string) => {
          ListItem() {
            Column() {
              this.ActionRow(row, '')
              Divider().color(DIVIDER).height(1).margin({ left: 18 })
            }
          }
        }, (row: string) => row)
      }
      .layoutWeight(1)
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  TextUnsavedDialog() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Text('')
          .width('100%')
          .height('100%')
          .backgroundColor(SCRIM)
      }
      .width('100%')
      .height('100%')
      Column() {
        Text('Unsaved Changes')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor(TEXT_PRIMARY)
          .width('100%')
          .padding({ left: 24, right: 24, top: 22, bottom: 8 })
          .accessibilityText('Unsaved Changes')
          .accessibilityDescription('Unsaved Changes')
        Text('Save changes before exiting?')
          .fontSize(15)
          .fontColor(TEXT_SECONDARY)
          .width('100%')
          .padding({ left: 24, right: 24, bottom: 10 })
          .accessibilityText('Save changes before exiting')
          .accessibilityDescription('Save changes before exiting')
        this.StatusBanner()
        Row() {
          Text('NO')
            .fontSize(14)
            .fontColor(PRIMARY)
            .fontWeight(FontWeight.Medium)
            .padding({ left: 20, right: 20, top: 14, bottom: 18 })
            .accessibilityText('NO')
            .accessibilityDescription('NO')
            .onClick(() => {
              this.recordAction('NO exits without save');
            })
          Blank().layoutWeight(1)
          Text('YES')
            .fontSize(14)
            .fontColor(PRIMARY)
            .fontWeight(FontWeight.Medium)
            .padding({ left: 20, right: 24, top: 14, bottom: 18 })
            .accessibilityText('YES')
            .accessibilityDescription('YES')
            .onClick(() => {
              this.recordAction('YES saves then exits');
            })
        }
        .width('100%')
      }
      .width('86%')
      .backgroundColor('#FFFFFF')
      .borderRadius(2)
      .shadow({ radius: 18, color: '#44000000', offsetX: 0, offsetY: 5 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  ArchiveMode() {
    Column() {
      this.Toolbar('sample.zip')
      this.StatusBanner()
      Row() {
        Text('Exit archive')
          .fontSize(14)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Medium)
          .padding({ left: 16, right: 16, top: 10, bottom: 10 })
          .backgroundColor(PRIMARY_DARK)
          .accessibilityText('Exit archive')
          .accessibilityDescription('Exit archive')
          .onClick(() => this.setState('main_default'))
      }
      .width('100%')
      .padding({ left: 12, top: 8, bottom: 8 })
      .backgroundColor(PRIMARY_DARK)
      List() {
        ForEach([
          { name: 'archive-folder', date: 'folder', kind: 'folder' },
          { name: 'resume.txt', date: '1 KB', kind: 'file' },
          { name: 'notes.txt', date: '1 KB', kind: 'file' }
        ], (item: FileRow) => {
          ListItem() {
            Column() {
            this.FileListRow(item)
              Divider().color(DIVIDER).height(1).margin({ left: 72, right: 16 })
            }
          }
        }, (item: FileRow) => item.name)
      }
      .layoutWeight(1)
      .backgroundColor(SURFACE)
      Row() {
        Text('Select all')
          .fontSize(16)
          .fontColor(TEXT_PRIMARY)
          .layoutWeight(1)
      }
      .height(56)
      .width('100%')
      .padding({ left: 18, right: 18 })
      .backgroundColor('#FFFFFF')
      .accessibilityText('Select all')
      .accessibilityDescription('Select all')
      .onClick(() => this.handleArchiveAction('Select all'))
      Row() {
        Text('Extract selected')
          .fontSize(16)
          .fontColor(TEXT_PRIMARY)
          .layoutWeight(1)
      }
      .height(56)
      .width('100%')
      .padding({ left: 18, right: 18 })
      .backgroundColor('#FFFFFF')
      .accessibilityText('Extract selected')
      .accessibilityDescription('Extract selected')
      .onClick(() => this.handleArchiveAction('Extract selected'))
      Row() {
        Text('Whole-archive extract')
          .fontSize(16)
          .fontColor(TEXT_PRIMARY)
          .layoutWeight(1)
      }
      .height(56)
      .width('100%')
      .padding({ left: 18, right: 18 })
      .backgroundColor('#FFFFFF')
      .accessibilityText('Whole-archive extract')
      .accessibilityDescription('Whole-archive extract')
      .onClick(() => this.handleArchiveAction('Whole-archive extract'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  UtilitiesPrompt() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Text('')
          .width('100%')
          .height('100%')
          .backgroundColor(SCRIM)
      }
      .width('100%')
      .height('100%')
      Column() {
        Text('Amaze Utils')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor(TEXT_PRIMARY)
          .width('100%')
          .padding({ left: 24, right: 24, top: 22, bottom: 12 })
        Text('Open this path with Amaze File Manager?')
          .fontSize(15)
          .fontColor(TEXT_SECONDARY)
          .width('100%')
          .padding({ left: 24, right: 24, bottom: 20 })
        Row() {
          Blank().layoutWeight(1)
          Text('Cancel')
            .fontSize(14)
            .fontColor(PRIMARY)
            .fontWeight(FontWeight.Medium)
            .padding({ left: 18, right: 18, top: 14, bottom: 18 })
            .accessibilityText('Cancel')
            .accessibilityDescription('Cancel button')
            .onClick(() => this.setState('main_default'))
        Text('OPEN')
            .fontSize(14)
            .fontColor(PRIMARY)
            .fontWeight(FontWeight.Medium)
            .padding({ left: 18, right: 24, top: 14, bottom: 18 })
            .accessibilityText('OPEN')
            .accessibilityDescription('OPEN')
            .onClick(() => this.setActionState('folder_open', 'OPEN'))
        }
        .width('100%')
      }
      .width('86%')
      .backgroundColor('#FFFFFF')
      .borderRadius(2)
      .shadow({ radius: 18, color: '#44000000', offsetX: 0, offsetY: 5 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  MainState() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      this.MainContent()
      if (this.stateId === 'main_drawer_open') {
        Row() {
          Text('Folder')
            .fontSize(1)
            .fontColor('#00FFFFFF')
            .width(1)
            .height(1)
            .accessibilityText('Folder')
            .accessibilityDescription('Folder')
          this.FloatingButton('main_fab_menu')
        }
        .margin({ right: 42, bottom: 72 })
      }
      if (this.stateId === 'main_drawer_open') {
        this.Drawer()
      }
      if (this.stateId === 'main_fab_menu') {
        Column() {
          Blank().layoutWeight(1)
          this.FabMenu()
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#CCFFFFFF')
      } else if (!this.selectionMode && !this.isOverlayState() && this.stateId !== 'main_drawer_open' && !this.isSearchState()) {
        Row() {
          Text('Folder')
            .fontSize(1)
            .fontColor('#00FFFFFF')
            .width(1)
            .height(1)
            .accessibilityText('Folder')
            .accessibilityDescription('Folder')
          this.FloatingButton('main_fab_menu')
        }
        .margin({ right: 42, bottom: 72 })
      }
      if (this.isSearchState()) {
        Stack({ alignContent: Alignment.Top }) {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#66FFFFFF')
          this.SearchBar()
        }
        .width('100%')
        .height('100%')
      }
      if (this.stateId === 'main_context_menu') {
        Stack({ alignContent: Alignment.TopEnd }) {
          Column() {
            Text('')
              .width('100%')
              .height('100%')
              .backgroundColor('#00FFFFFF')
              .onClick(() => this.setState('main_default'))
          }
          .width('100%')
          .height('100%')
          Column() {
            this.ContextMenu()
          }
          .margin({ top: 176, right: 6 })
        }
        .width('100%')
        .height('100%')
      }
      if (this.stateId === 'compress_dialog') {
        Stack({ alignContent: Alignment.Top }) {
          Column() {
            Text('')
              .width('100%')
              .height('100%')
              .backgroundColor(SCRIM)
          }
          .width('100%')
          .height('100%')
          Column() {
            this.DialogCard('Enter Zip Name', '.zip', '.zip', false)
          }
          .width('100%')
          .margin({ top: 94 })
        }
        .width('100%')
        .height('100%')
      }
      if (this.stateId === 'new_folder_dialog') {
        Stack({ alignContent: Alignment.Top }) {
          Column() {
            Text('')
              .width('100%')
              .height('100%')
              .backgroundColor(SCRIM)
          }
          .width('100%')
          .height('100%')
          Column() {
            this.DialogCard('New Folder', 'Enter Name', '', false)
          }
          .width('100%')
          .margin({ top: 94 })
        }
        .width('100%')
        .height('100%')
      }
      if (this.stateId === 'new_file_dialog') {
        Stack({ alignContent: Alignment.Center }) {
          Column() {
            Text('')
              .width('100%')
              .height('100%')
              .backgroundColor(SCRIM)
          }
          .width('100%')
          .height('100%')
          this.DialogCard('New File', 'new-file.txt', 'new-file.txt', true)
        }
        .width('100%')
        .height('100%')
      }
      if (this.stateId === 'delete_confirm') {
        this.ConfirmationSurface('Delete selected item?', 'DELETE')
      }
      if (this.stateId === 'restore_confirm') {
        this.ConfirmationSurface('Restore selected item?', 'DONE')
      }
      if (this.stateId === 'sort_sheet') {
        Stack({ alignContent: Alignment.Bottom }) {
          Column() {
            Text('')
              .width('100%')
              .height('100%')
              .backgroundColor(SCRIM)
          }
          .width('100%')
          .height('100%')
          Column() {
            Text('Sort by')
              .fontSize(20)
              .fontColor(TEXT_PRIMARY)
              .fontWeight(FontWeight.Medium)
              .width('100%')
              .padding({ left: 20, top: 18, bottom: 8 })
            this.ActionRow('Name', 'Ascending')
            this.ActionRow('Date', '')
            this.ActionRow('Size', '')
            this.ActionRow('Type', '')
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
        }
        .width('100%')
        .height('100%')
      }
      if (this.stateId === 'archive_extract_dialog') {
        this.ConfirmationSurface('Extract archive', 'EXTRACT')
      }
      if (this.stateId === 'properties_sheet') {
        this.SimpleSurface('Properties', ['Name', 'Path', 'Size', 'Permissions', 'Copy value'])
      }
      if (this.stateId === 'text_details_sheet') {
        this.TextDetailsSurface()
      }
      if (this.stateId === 'text_unsaved_dialog') {
        this.TextUnsavedDialog()
      }
      if (this.stateId === 'open_as_sheet') {
        this.SimpleSurface('Open As', ['Text', 'Image', 'Video', 'Audio', 'Database', 'Other'])
      }
      if (this.stateId === 'rename_dialog') {
        Stack({ alignContent: Alignment.Center }) {
          Column() {
            Text('')
              .width('100%')
              .height('100%')
              .backgroundColor(SCRIM)
          }
          .width('100%')
          .height('100%')
          this.DialogCard('Rename', 'Alarms', 'Alarms', true)
        }
        .width('100%')
        .height('100%')
      }
      if (this.stateId === 'paste_mode') {
        Stack({ alignContent: Alignment.Bottom }) {
          Column() {
            Text('')
              .width('100%')
              .height('100%')
              .backgroundColor('#11000000')
          }
          .width('100%')
          .height('100%')
          Row() {
            Text('PASTE')
              .fontSize(14)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Medium)
              .padding({ left: 22, right: 22, top: 14, bottom: 14 })
              .backgroundColor(PRIMARY)
              .onClick(() => this.setActionState('main_default', 'PASTE'))
            Text('CANCEL')
              .fontSize(14)
              .fontColor(PRIMARY)
              .fontWeight(FontWeight.Medium)
              .padding({ left: 22, right: 22, top: 14, bottom: 14 })
              .backgroundColor('#FFFFFF')
              .onClick(() => this.setActionState('main_default', 'CANCEL'))
          }
          .width('100%')
          .padding({ left: 12, right: 12, bottom: 20 })
          .backgroundColor('#FFFFFF')
        }
        .width('100%')
        .height('100%')
      }
      if (this.stateId === 'cloud_connection') {
        this.SimpleSurface('Cloud Connection', ['Google Drive', 'Dropbox', 'Add account'])
      }
      if (this.stateId === 'storage_analysis') {
        this.SimpleSurface('Storage Analysis', ['Storage usage', 'Large files', 'Internal Storage'])
      }
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  PreferenceToolbar(title: string) {
    Row() {
      this.IconButton($r('app.media.ic_arrow_back_white_36dp'), 'Navigate up', this.parentForState(this.stateId))
      Text(title)
        .fontSize(19)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
        .layoutWeight(1)
        .margin({ left: 8 })
    }
    .height(54)
    .width('100%')
    .backgroundColor(PRIMARY)
  }

  @Builder
  PrefIcon(title: string) {
    Stack() {
      if (title === 'Appearance') {
        Image($r('app.media.ic_preference_appearance')).width(42).height(42).objectFit(ImageFit.Contain)
      } else if (title === 'Interface') {
        Image($r('app.media.ic_preference_ui')).width(42).height(42).objectFit(ImageFit.Contain)
      } else if (title === 'Behavior') {
        Image($r('app.media.ic_preference_behavior')).width(42).height(42).objectFit(ImageFit.Contain)
      } else if (title === 'Security') {
        Image($r('app.media.ic_preference_security')).width(42).height(42).objectFit(ImageFit.Contain)
      } else if (title === 'Backup') {
        Image($r('app.media.ic_preference_settings_backup_restore')).width(42).height(42).objectFit(ImageFit.Contain)
      } else if (title === 'About Amaze File Manager') {
        Image($r('app.media.ic_preference_info')).width(42).height(42).objectFit(ImageFit.Contain)
      }
    }
    .width(42)
    .height(42)
  }

  @Builder
  SwitchGlyph(enabled: boolean) {
    Row() {
      Circle()
        .width(16)
        .height(16)
        .fill(enabled ? '#FFFFFF' : '#F5F5F5')
        .margin({ left: enabled ? 20 : 2 })
    }
    .width(38)
    .height(20)
    .borderRadius(10)
    .backgroundColor(enabled ? '#F06292' : '#BDBDBD')
    .padding(2)
  }

  @Builder
  PreferenceList(rows: PreferenceRow[], root: boolean) {
    List() {
      ListItem() {
        this.StatusBanner()
      }
      ForEach(rows, (row: PreferenceRow, index: number) => {
        ListItem() {
          Column() {
            Row() {
              if (root) {
                Row() {
                  this.PrefIcon(row.title)
                }
                  .width(72)
                  .justifyContent(FlexAlign.Center)
              } else {
                Blank().width(56)
              }
              Column() {
                Text(row.title)
                  .fontSize(root ? 16 : 15)
                  .fontColor(TEXT_PRIMARY)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                if (this.preferenceSummary(row).length > 0) {
                  Text(this.preferenceSummary(row))
                    .fontSize(12)
                    .fontColor(TEXT_SECONDARY)
                    .margin({ top: 3 })
                    .maxLines(3)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              .padding({ right: 12 })
              if (row.control === 'switch') {
                Row() {
                  this.SwitchGlyph(this.preferenceChecked(row))
                }
                  .margin({ right: 18 })
              }
            }
            .height(root ? 78 : 100)
            .width('100%')
            .backgroundColor('#FFFFFF')
            .onClick(() => this.handlePreference(row))
            Divider().color(root ? '#11FFFFFF' : '#08FFFFFF').height(1).margin({ left: root ? 72 : 64 })
          }
        }
      }, (row: PreferenceRow) => row.title)
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#FFFFFF')
  }

  @Builder
  SettingsPage(title: string, rows: PreferenceRow[], root: boolean) {
    Column() {
      this.PreferenceToolbar(title)
      this.PreferenceList(rows, root)
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#FFFFFF')
  }

  @Builder
  CurrentPage() {
    if (this.stateId === 'archive_mode') {
      this.ArchiveMode()
    } else if (this.stateId === 'utilities_prompt') {
      this.UtilitiesPrompt()
    } else if (this.stateId === 'ftp_server') {
      this.FtpServerPage()
    } else if (this.stateId === 'text_editor') {
      this.TextEditorPage()
    } else if (this.stateId === 'trash_bin') {
      this.SimpleSurface('Trash Bin', ['Deleted file.txt', 'Restore', 'Delete forever'])
    } else if (this.stateId === 'bookmark_edit') {
      this.SimpleSurface('Bookmark', ['Drawer bookmark placeholder', 'Edit bookmark', 'Delete bookmark'])
    } else if (this.stateId === 'about_page') {
      this.AboutPage()
    } else if (this.stateId === 'about_licenses') {
      this.AboutLicensesPage()
    } else if (this.stateId === 'license_list') {
      this.LicenseListPage()
    } else if (this.stateId === 'text_monospace') {
      this.SimpleSurface('Text Editor', ['Monospace font', 'Font enabled', 'Save'])
    } else if (this.stateId === 'text_details_sheet') {
      this.TextDetailsSurface()
    } else if (this.stateId === 'text_unsaved_dialog') {
      this.TextUnsavedDialog()
    } else if (this.stateId.startsWith('setting_action_')) {
      this.SettingActionPage()
    } else if (this.stateId === 'settings_root') {
      this.SettingsPage('Settings', this.settingsRoot, true)
    } else if (this.stateId === 'settings_appearance') {
      this.SettingsPage('Appearance', this.appearanceRows, false)
    } else if (this.stateId === 'settings_color') {
      this.SettingsPage('Colors', this.colorRows, false)
    } else if (this.stateId === 'settings_ui') {
      this.SettingsPage('Interface', this.interfaceRows, false)
    } else if (this.stateId === 'settings_bookmarks') {
      this.SettingsPage('Bookmarks', this.bookmarkRows, false)
    } else if (this.stateId === 'settings_quick_access') {
      this.SettingsPage('Quick access', this.quickAccessRows, false)
    } else if (this.stateId === 'settings_behavior') {
      this.SettingsPage('Behavior', this.behaviorRows, false)
    } else if (this.stateId === 'settings_security') {
      this.SettingsPage('Security', this.securityRows, false)
    } else if (this.stateId === 'settings_backup') {
      this.SettingsPage('Backup', this.backupRows, false)
    } else if (MAIN_STATES.includes(this.stateId)) {
      this.MainState()
    } else {
      this.MainState()
    }
  }

  build() {
    Column() {
      this.CurrentPage()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  onBackPress(): boolean {
    if (this.stateId === 'main_default') {
      this.recordAction('Back press again to exit');
      return true;
    }
    this.goBack();
    return true;
  }
}
