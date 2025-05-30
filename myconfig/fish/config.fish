if status is-interactive
    set -g fish_greeting ''

    export EDITOR=/usr/bin/helix
    export PATH="$HOME/.config/myscripts/:$PATH"
    export PATH="$PATH:$HOME/.cargo/bin/"
    export DIFFPROG=meld

    bind \eh 'wtype !!\n'
    bind \e\r 'wtype -M ctrl -k f -m ctrl ; wtype \n'
    bind \er 'wtype -M alt -k Left -m alt'
    bind \en 'wtype -M alt -k Right -m alt'
    bind \ew backward-kill-path-component
    bind \eg 'wtype " | grep "'

    if test $(cat ~/.ssh/state_connect) = yes
        ssh_agent_init
    end

    starship init fish | source
    zoxide init --cmd e fish | source

    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end
end
