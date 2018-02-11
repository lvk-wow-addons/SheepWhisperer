# Sheep Whisperer

This simple addon, with no settings, no config, no options, no nothing, will sit in the background
and detect that you or someone in your party is casting one of the polymorph-like spells.

When it detects that *you* are casting such a spell, it will check if someone in your party is
targetting the same mob that you are, and if so, it will send them a whisper about it and tell
them to please consider changing their target.

Here's the type of message being sent:

    [Arxas] whispers: I am casting Polymorph on your target, Botani Grower, please change to a different target if possible

Currently the addon detects the following spells:

* Polymorph
* Shackle Undead

I assume it will only handle english clients for now.

The addon will only work in normal groups, not in raids. I will consider adding
support for this later.