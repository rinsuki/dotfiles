// @ts-check
const electron = require("electron")

/** @type {[string, string, string][]} */
const patches = [
    [".SIGNAL_AV1_DECODE,!0)", ".SIGNAL_AV1_DECODE,!1)", "Disable AV1 software decode, for laptop battery"],
]

electron.dialog.showMessageBox({
    title: "hello",
    message: "hi",
})

electron.protocol.handle("https", async req => {
    // process.stderr.write(`got request for ${req.url}\n`)
    const res = await electron.net.fetch(req, {
        bypassCustomProtocolHandlers: true,
    })
    if (req.url.endsWith(".js")) {
        // check response
        const rf = res.clone()
        let text = await rf.text()
        let patched = false
        for (const [before, after, patchName] of patches) {
            if (text.includes(before)) {
                text = text.replaceAll(before, after)
                process.stderr.write(`patched ${req.url} by ${patchName}\n`)
                patched = true
            }
        }
        if (patched) {
            return new Response(text, {
                headers: res.headers,
                status: res.status,
                statusText: res.statusText,
            })
        }
    }
    return res
})
module.exports = function() {
    
}