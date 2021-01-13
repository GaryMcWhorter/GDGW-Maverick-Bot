proc startsWith*(msg: string, prefix: string): bool =
    if msg.len <= prefix.len:
        return false
    for i in 0 ..< prefix.len:
        if prefix[i] != msg[i]:
            return false
    return true
