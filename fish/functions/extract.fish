function extract
    if test (count $argv) -ne 1
        echo "You must only provide one file"
        return 1
    end

    if test -f $argv[1]
        echo "The argument must be a file"
        return 1
    end

    switch $argv[1]
        case "*.tar.bz2" "*.tbz2"
            tar xjf "$argv[1]"
        case "*.tar.gz" "*.tgz"
            tar xzf "$argv[1]"
        case "*.tar.xz"
            tar xf "$argv[1]"
        case "*.bz2"
            bunzip2 $argv[1]
        case "*.rar"
            unrar x $argv[1]
        case "*.gz"
            gunzip $argv[1]
        case "*.tar"
            tar xf $argv[1]
        case "*.zip"
            unzip $argv[1]
        case "*.Z"
            uncompress $argv[1]
        case "*.7z"
            7zr e $argv[1]
        case "*.rpm"
            rpm2cpio $argv[1] | cpio -idmv
        case "*"
            echo "Can't `extract` this file. Please check."
    end
end
