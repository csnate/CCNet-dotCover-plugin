function toggleNodes(el) {
    var display,
        jEl = $(el),
        tr = jEl.parent().parent().parent(),
        xmlNodeLevel = tr.attr('xmlnodelevel') * 1;
    if (tr.next() == null) return;
    if (jEl.hasClass("expand")) {
        jEl.addClass("collapse");
        jEl.removeClass("expand");
        display = "";
    } else {
        jEl.addClass("expand");
        jEl.removeClass("collapse");
        display = "none";
    }
    while(tr.next() != null && tr.next().attr('xmlnodelevel') * 1 > xmlNodeLevel) {
        tr = tr.next();
        var nextNodeLevel = tr.attr('xmlnodelevel') * 1,
            hasExpand = jEl.hasClass("expand");
        if (
            (hasExpand && nextNodeLevel > xmlNodeLevel)
            || (nextNodeLevel == xmlNodeLevel + 1)
        ) {
            tr.css("display", display);
            var iconNode = tr.children(":first-child").children(":first-child").children(":first-child");
            if (hasExpand && iconNode.hasClass("collapse")) {
                iconNode.addClass("expand");
            }
        }
    }
}