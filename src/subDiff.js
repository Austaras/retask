export function sameSub(kind, param, oldKind, oldParam) {
    if (kind !== oldKind) return false
    if (Array.isArray(param) && Array.isArray(oldParam)) {
        if (param.length !== oldParam.length) return false
        for (var i = 0; i < param.length; i++) {
            if (param[i] !== oldParam[i]) return false
        }
        return true
    }
    if (!Array.isArray(param) && !Array.isArray(oldParam)) {
        return param === oldParam
    }
    return false
}
