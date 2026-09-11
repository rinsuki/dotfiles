/*
 * Vencord, a Discord client mod
 * Copyright (c) 2026 rinsuki
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import { ConnectSrc, CspPolicies, ImageSrc } from "@main/csp";
import { app, session } from "electron";

CspPolicies["api.fxtwitter.com"] = ConnectSrc;
CspPolicies["pbs.twimg.com"] = ImageSrc;
CspPolicies["video.twimg.com"] = ["media-src"];

const findHeader = (headers: Record<string, string>, headerName: Lowercase<string>) => {
    return Object.keys(headers).find(h => h.toLowerCase() === headerName);
};

app.whenReady().then(() => {
    session.defaultSession.webRequest.onBeforeSendHeaders({
        urls: ["https://video.twimg.com/*"],
        types: ["media"]
    }, ({ requestHeaders }, cb) => {
        const referer = findHeader(requestHeaders, "referer");
        if (referer != null) delete requestHeaders[referer];
        cb({
            requestHeaders
        });
    });
});
