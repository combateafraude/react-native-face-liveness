import * as React from 'react';

import { StyleSheet, View, Button } from 'react-native';
import {
  useFaceLiveness,
  startFaceLiveness,
} from 'react-native-iproov-lib-test';

export default function App() {
  const MOBILE_TOKEN =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI2MzMzNzY5YzU4ZTY5YzAwMDliM2I4MjUifQ.KwqiGAORlETNAeAqMpA42C1YH7EJrQlmAZfIWOtt2GU';
  const PERSON_ID = '43485449806';

  const {} = useFaceLiveness({ stage: 'PROD', filter: 'NATURAL' });

  return (
    <View style={styles.container}>
      <Button
        title="Press"
        onPress={() => startFaceLiveness(MOBILE_TOKEN, PERSON_ID)}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
