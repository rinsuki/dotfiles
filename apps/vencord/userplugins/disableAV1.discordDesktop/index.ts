/*
 * Vencord, a Discord client mod
 * Copyright (c) 2026 rinsuki
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import definePlugin from "@utils/types";

export default definePlugin({
    name: "Disable AV1",
    description: "Please Don't Decode Video on Software",
    authors: [],

    patches: [
        {
            find: ".SIGNAL_AV1_DECODE,!0)",
            replacement: [{
                match: /\.SIGNAL_AV1_DECODE,!0\)/g,
                replace: ".SIGNAL_AV1_DECODE,!1)",
            }]
        }
    ]
});
