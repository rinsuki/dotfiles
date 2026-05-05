const electron = require("electron")
const coreasar = require("./core.asar")
const path = require("node:path")

try {
    const injected = require(path.join(process.env.HOME, "dotfiles", "discord", "main", "injected", "index.js"))
    injected(coreasar)
} catch(e) {
    try {
        electron.dialog.showMessageBoxSync({
            type: "error",
            title: "failed to run injected code",
            message: `${e}\n${e.stack}`
        })
    } finally {
        process.exit(1)
    }
}
module.exports = coreasar