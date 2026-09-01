import { Tabs } from "expo-router";
import { BookmarkBar } from "@/components/ui/bottom-nav";

export default function TabsLayout() {
  return (
    <Tabs
      tabBar={(props) => <BookmarkBar {...props} />}
      screenOptions={{
        headerShown: false,
        sceneStyle: { backgroundColor: "#FDFCF8" },
        lazy: true,
        freezeOnBlur: true,
        animation: "shift",
      }}
    >
      <Tabs.Screen name="home" options={{ title: "Ruang" }} />
      <Tabs.Screen name="notes" options={{ title: "Catatan" }} />
      <Tabs.Screen name="memories" options={{ title: "Kenangan" }} />
      <Tabs.Screen name="timeline" options={{ title: "Jejak" }} />
      <Tabs.Screen name="profile" options={{ title: "Kita" }} />
    </Tabs>
  );
}
