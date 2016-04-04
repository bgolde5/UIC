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
        clipMap.put("1", R.raw.ave_maria);
        clipMap.put("2", R.raw.chanson);
        clipMap.put("3", R.raw.ave_maria);
    }

    public static int getResID(String clip) {
        return (int)clipMap.get(clip);
    }
}
