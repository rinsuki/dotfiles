import fs from "node:fs"
import process from "node:process"

const VALID_CHANNELS = ["discord", "discordcanary", "discordptb"]

function install(channel: string) {
  if (VALID_CHANNELS.indexOf(channel) === -1) {
    console.error(`Invalid channel. Please specify one of: ${VALID_CHANNELS.join(", ")}`)
    process.exit(1)
  }
  const discordDir = `${process.env.HOME}/Library/Application Support/${channel}`
  const inVersionPath = `modules/discord_desktop_core/index.js`
  const inVersionPathApp = `modules/discord_desktop_core-1/discord_desktop_core/index.js`
  const targetFilesKouho = fs.readdirSync(discordDir).map(x => {
    if (!x.includes("0.")) return false
    if (x.startsWith("app-")) {
      return `${discordDir}/${x}/${inVersionPathApp}`
    } else {
      return `${discordDir}/${x}/${inVersionPath}`
    }
  }).filter(x => x) as string[]
  const targetFiles = targetFilesKouho.filter(x => x && fs.existsSync(x)) as string[]
  if (targetFiles.length === 0) {
    console.error("No valid Discord versions found.", targetFilesKouho)
    process.exit(1)
  }
  targetFiles.sort()
  const targetPath = targetFiles[targetFiles.length - 1]
  // 一応それっぽいか確認しとく
  const targetContent = fs.readFileSync(targetPath)
  const expectedChunks = [
    "module.exports = ",
    "require(",
    "./core.asar",
  ]
  for (const expectedChunk of expectedChunks) {
    if (!targetContent.includes(expectedChunk)) {
      console.error(`Invalid target content. Missing chunk: ${expectedChunk}`)
      process.exit(1)
    }
  }
  const sourcePath = `${import.meta.dirname!}/main/discord_desktop_core/index.js`
  fs.statSync(sourcePath) // 存在するか確認しておく
  fs.copyFileSync(sourcePath, targetPath)
  console.log(`Installed successfully to ${targetPath}`)
}

install(process.argv[2])
