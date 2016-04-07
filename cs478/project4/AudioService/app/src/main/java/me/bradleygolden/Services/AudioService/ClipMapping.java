package me.bradleygolden.Services.AudioService;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by bradleygolden on 4/2/16.
 */
public final class ClipMapping {

    private static Map clipMap;

    static {
        clipMap = new HashMap();
        clipMap.put("Ocean Motion", R.raw.ocean_motion);
        clipMap.put(R.raw.ocean_motion, 1);
        clipMap.put("Ave Maria", R.raw.ave_maria);
        clipMap.put(R.raw.ave_maria, 2);
        clipMap.put("Chanson", R.raw.chanson);
        clipMap.put(R.raw.chanson, 3);
    }

    public static int getResID(String clip) {
        return (int)clipMap.get(clip);
    }

    public static int getClipNumber(int clipId) {
        return (int)clipMap.get(clipId);
    }
}
