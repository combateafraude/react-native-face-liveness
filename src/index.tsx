import { useState, useEffect } from 'react';
import { NativeModules, NativeEventEmitter, Platform } from 'react-native';

export interface FaceLivenessResponse {
  result: string | null;
  error: string | null;
  cancelled: string | null;
  isLoading: boolean;
}

export type StageType = 'PROD' | 'BETA' | 'DEV';
export type FilterType = 'NATURAL' | 'LINE_DRAWING';

export interface FaceLivenessProps {
  stage?: StageType;
  filter?: FilterType;
}

const LINKING_ERROR =
  `The package 'react-native-iproov-lib-test' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const module = NativeModules.IproovLibTest
  ? NativeModules.IproovLibTest
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const moduleEventEmitter = new NativeEventEmitter(module);

let staged: StageType = 'PROD';
let filtered: FilterType = 'LINE_DRAWING';

export function startFaceLiveness(mobileToken: string, peopleId: string) {
  return module.startFaceLiveness(mobileToken, peopleId, staged, filtered);
}

export function useFaceLiveness(
  options?: FaceLivenessProps
): FaceLivenessResponse {
  const [result, setResult] = useState<string | null>(null);
  const [cancelled, setCancelled] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(false);

  if (options) {
    if (options.stage) {
      staged = options.stage;
    } else {
      staged = 'PROD';
    }

    if (options.filter) {
      filtered = options.filter;
    } else {
      filtered = 'LINE_DRAWING';
    }
  } else {
    staged = 'PROD';
    filtered = 'LINE_DRAWING';
  }

  useEffect(() => {
    moduleEventEmitter.addListener('onFaceLivenessSuccess', (event) => {
      setResult(event);
      setError(null);
      setCancelled(null);
    });

    moduleEventEmitter.addListener('onFaceLivenessError', (event) => {
      setError(event);
      setCancelled(null);
    });

    moduleEventEmitter.addListener('onFaceLivenessCancel', (event) => {
      setError(null);
      setCancelled(event);
    });

    moduleEventEmitter.addListener('onFaceLivenessLoading', (event) =>
      setIsLoading(event)
    );

    moduleEventEmitter.addListener('onFaceLivenessLoaded', (event) =>
      setIsLoading(!event)
    );
  }, []);

  return { result, error, cancelled, isLoading };
}
