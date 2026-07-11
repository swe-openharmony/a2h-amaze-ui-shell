export interface BenchmarkLaunchContext {
  surface: string;
  fixture: string;
}

let context: BenchmarkLaunchContext = {
  surface: '',
  fixture: ''
};

export function setBenchmarkLaunch(surface: string, fixture: string): void {
  context = { surface: surface, fixture: fixture };
}

export function getBenchmarkLaunch(): BenchmarkLaunchContext {
  return context;
}
