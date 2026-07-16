import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { setBenchmarkLaunch } from '../runtime/BenchmarkLaunch';

const DOMAIN = 0x0000;
const PUBLIC_SURFACES: Record<string, boolean> = {
  'home': true,
  'folder': true,
  'text_editor': true,
  'archive': true,
  'about': true,
  'settings': true,
  'settings_appearance': true,
  'settings_interface': true,
  'settings_behavior': true,
  'settings_bookmarks': true,
  'settings_security': true,
  'settings_backup': true,
  'trash': true,
  'ftp_server': true
};
const PUBLIC_FIXTURES: Record<string, boolean> = {
  'sample_files': true,
  'sample_bookmarks': true
};

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, _launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    this.captureBenchmarkLaunch(want);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    try {
      const windowClass = windowStage.getMainWindowSync();
      windowClass.setWindowSystemBarProperties({
        statusBarColor: '#303F9F',
        statusBarContentColor: '#000000',
        navigationBarColor: '#FFFFFF',
        navigationBarContentColor: '#666666'
      });
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set system bar properties. Cause: %{public}s', JSON.stringify(err));
    }

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onNewWant(want: Want, _launchParam: AbilityConstant.LaunchParam): void {
    this.captureBenchmarkLaunch(want);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onNewWant');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  private captureBenchmarkLaunch(want: Want): void {
    const requestedSurface = want.parameters?.['benchmark_surface'] as string;
    const requestedFixture = want.parameters?.['benchmark_fixture'] as string;
    const surface = requestedSurface && PUBLIC_SURFACES[requestedSurface] ? requestedSurface : '';
    const fixture = requestedFixture && PUBLIC_FIXTURES[requestedFixture] ? requestedFixture : '';
    setBenchmarkLaunch(surface, fixture);
  }
}
