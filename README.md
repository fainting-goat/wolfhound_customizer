# Wolfhound Customizer

This app allows users to create custom resource packs for the game Minecraft.  It was designed specifically to 
work with Wolfhound, but can be adapted to work with any set of texture packs.

## How To Run

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Any changes to the images will require a server restart.  The list of files is built on startup and is not
rebuilt at any point.

## How to Use Setup Textures

  * Drop your unzipped texture packs into priv/static/files (chosen arbitrarily because I don't know what I'm doing with assets)
  * Run `elixir script/arrange_files.ex`
  
This will move your textures into an images folder in a structure that the app can follow.  You'll need to 
add the blockstates folder to `priv/static` manually so it can be included in the final zip folder.

## Hardcoding

My assumption was that I'm the only one that'll use this, so there's some hardcoded bits to fit my packs.  
My pack variations are hardcoded in the item index template.

## Testing

In the ancient and venerable tradition of personal projects, there are no tests.
