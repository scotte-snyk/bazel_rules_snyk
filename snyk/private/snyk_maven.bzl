load("//snyk/private:snyk.bzl", "snyk_aspect")

def _snyk_scan_maven_impl(ctx):
    # collection and processing of transitives for maven goes here
    print('_snyk_scan_maven_impl | hanlding of maven transitives here')
    print('_snyk_scan_maven_impl | name=' + str(ctx.attr.name))
    print("_snyk_scan_maven_impl | oss_type=" + str(ctx.attr.oss_type))
    print("_snyk_scan_maven_impl | target=" + str(ctx.attr.target.label))

snyk_scan_maven = rule(
    implementation = _snyk_scan_maven_impl,
    attrs = {
        'target' : attr.label(aspects = [snyk_aspect]),
        'deps' : attr.label_list(aspects = [snyk_aspect]),
        'oss_type' : attr.string(default = 'maven'),
    },
)

# snyk_maven macro will create targets for snyk (test/monitor/depgraph)
def snyk_maven(name, target, out = None, **kwargs):
    snyk_scan_maven(
        name = target.replace(":","") + "." + name + "_test",
        target = target,
        **kwargs
    )

    snyk_scan_maven(
        name = target.replace(":","") + "." + name + "_monitor",
        target = target,
        **kwargs
    )

    snyk_scan_maven(
        name = target.replace(":","") + "." + name + "_depgraph",
        target = target,
        **kwargs
    )