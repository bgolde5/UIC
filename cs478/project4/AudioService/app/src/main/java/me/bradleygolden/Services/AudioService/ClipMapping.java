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
        clipMap.put("Chanson", R.raw.chanson);
        clipMap.put("Ave Maria", R.raw.ave_maria);
    }

    public static int getResID(String clip) {
        return (int)clipMap.get(clip);
    }
}
