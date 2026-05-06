import os
import configparser
import datetime
import hashlib
import urllib.request

PLUGINS = [
    ("ami-columns/__init__.py", "https://gitlab.com/SuperSaltyGamer/ami/-/raw/acead086fe7575f878af2f11da19776e9d44c8de/ami-columns/__init__.py", bytes.fromhex("2d57bbca85e567a48b273989e3adc959601ffba9366e6d067e1ef775b295319f")),
]

def main():
    # --- plugins
    picard_plugins_dir = os.environ["HOME"] + "/Library/Preferences/MusicBrainz/Picard/plugins"
    assert os.path.isdir(picard_plugins_dir)
    for path, url, expected_sha256 in PLUGINS:
        if not os.path.exists(os.path.join(picard_plugins_dir, path)):
            print(f"Downloading {path}...")
            os.makedirs(os.path.dirname(os.path.join(picard_plugins_dir, path)), exist_ok=True)
            with urllib.request.urlopen(url) as response:
                data = response.read()
            with open(os.path.join(picard_plugins_dir, path), "wb") as f:
                f.write(data)
        with open(os.path.join(picard_plugins_dir, path), "rb") as f:
            actual_sha256 = hashlib.sha256(f.read()).digest()
        assert actual_sha256 == expected_sha256, f"SHA256 mismatch for {path}: expected {expected_sha256.hex()}, got {actual_sha256.hex()}"
    # --- ini
    picard_ini_path = os.environ["HOME"] + "/.config/MusicBrainz/Picard.ini"
    assert os.path.exists(picard_ini_path), "picard.ini not found at {}, please launch Picard first.".format(picard_ini_path)
    config = configparser.RawConfigParser()
    config.optionxform = lambda optionstr: optionstr
    with open(picard_ini_path, "r") as configfile:
        config.read_string(configfile.read())
    # ami columns column
    config["setting"]["enabled_plugins"] = r'@Variant(\0\0\0\t\0\0\0\x1\0\0\0\n\0\0\0\x16\0\x61\0m\0i\0-\0\x63\0o\0l\0u\0m\0n\0s)'
    config["setting"]["ami_columns_columns"] = r'@Variant(\0\0\0\x7f\0\0\0\xePyQt_PyObject\0\0\0\0%\x80\x4\x95\x1a\0\0\0\0\0\0\0\x8c\x6\xe7\xb7\xa8\xe6\x9b\xb2\x94\x88\x8c\n%arranger%\x94\x87\x94.), @Variant(\0\0\0\x7f\0\0\0\xePyQt_PyObject\0\0\0\0%\x80\x4\x95\x1a\0\0\0\0\0\0\0\x8c\x6\xe4\xbd\x9c\xe8\xa9\x9e\x94\x88\x8c\n%lyricist%\x94\x87\x94.), @Variant(\0\0\0\x7f\0\0\0\xePyQt_PyObject\0\0\0\0\x34\x80\x4\x95)\0\0\0\0\0\0\0\x8c\x6\xe5\xb1\x9e\xe6\x80\xa7\x94\x88\x8c\x19%_performance_attributes%\x94\x87\x94.)'
    # preserve ISRC (don't overwrite it with MusicBrainz data)
    config["setting"]["preserved_tags"] = r'@Variant(\0\0\0\t\0\0\0\x1\0\0\0\n\0\0\0\b\0i\0s\0r\0\x63)'
    # 
    config["persist"]["show_changes_first"] = "true"
    config["setting"]["track_ars"] = "true" # トラックの関連性を使用する (これがないと作曲者とかが入らない)
    config["setting"]["enable_tagger_scripts"] = "true"
    config["setting"]["list_of_scripts"] = r'"@Variant(\0\0\0\x7f\0\0\0\xePyQt_PyObject\0\0\0\0\x8e\x80\x4\x95\x83\0\0\0\0\0\0\0(K\0\x8c\xeUseDescription\x94\x88\x8ch$set(album,%album%$if($and(%_releasecomment%,$ne(%_releasecomment%,\xe9\x80\x9a\xe5\xb8\xb8\xe7\x9b\xa4)), \\(%_releasecomment%\\)))\n\x94t\x94.)", "@Variant(\0\0\0\x7f\0\0\0\xePyQt_PyObject\0\0\0\0o\x80\x4\x95\x64\0\0\0\0\0\0\0(K\x1\x8c\x1aUseWriterIfComposerIsEmpty\x94\x88\x8c=$if($and($not(%composer%),%writer%),$set(composer,%writer%))\n\x94t\x94.)"'
    config["setting"]["save_images_to_tags"] = "false"
    with open(picard_ini_path + ".new", "w") as configfile:
        config.write(configfile, space_around_delimiters=False)
    os.rename(picard_ini_path, picard_ini_path + "." + datetime.datetime.now().strftime("%Y%m%d%H%M%S") + ".bak")
    os.rename(picard_ini_path + ".new", picard_ini_path)
    print("Done")

if __name__ == "__main__":
    main()
