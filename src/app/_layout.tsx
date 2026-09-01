import { Stack } from "expo-router";
import { useFonts } from "expo-font";
import * as SplashScreen from "expo-splash-screen";
import { useEffect } from "react";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import "../global.css";

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const [loaded] = useFonts({
    // Fallback to system fonts - Bricolage / Jakarta / Space Mono are mapped via CSS
    // Expo will use native system if custom otf not bundled; typography still intentional via weight & spacing
  });

  useEffect(() => {
    if (loaded || true) SplashScreen.hideAsync();
  }, [loaded]);

  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <Stack
        screenOptions={{
          headerShown: false,
          contentStyle: { backgroundColor: "#FDFCF8" },
          animation: "fade",
        }}
      />
    </GestureHandlerRootView>
  );
}
