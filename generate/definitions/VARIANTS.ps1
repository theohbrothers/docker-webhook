
# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    @{
        package = 'webhook'
        package_version = '2.8.0'
        distro = 'alpine'
        distro_version = '3.14'
        subvariants = @(
            @{ components = @(); tag_as_latest = $true }
            @{ components = @( 'sops' ) }
        )
    }
    @{
        package = 'webhook'
        package_version = '2.7.0'
        distro = 'alpine'
        distro_version = '3.14'
        subvariants = @(
            @{ components = @() }
            @{ components = @( 'sops' ) }
        )
    }
    @{
        package = 'webhook'
        package_version = '2.8.0'
        distro = 'alpine'
        distro_version = '3.13'
        subvariants = @(
            @{ components = @() }
            @{ components = @( 'sops' ) }
        )
    }
    @{
        package = 'webhook'
        package_version = '2.7.0'
        distro = 'alpine'
        distro_version = '3.13'
        subvariants = @(
            @{ components = @() }
            @{ components = @( 'sops' ) }
        )
    }
    @{
        package = 'webhook'
        package_version = '2.8.0'
        distro = 'alpine'
        distro_version = '3.12'
        subvariants = @(
            @{ components = @() }
            @{ components = @( 'sops' ) }
        )
    }
    @{
        package = 'webhook'
        package_version = '2.7.0'
        distro = 'alpine'
        distro_version = '3.12'
        subvariants = @(
            @{ components = @() }
            @{ components = @( 'sops' ) }
        )
    }
)

$VARIANTS = @(
    foreach ($variant in $VARIANTS_MATRIX){
        foreach ($subVariant in $variant['subvariants']) {
            @{
                # Metadata object
                _metadata = @{
                    package_version = $variant['package_version']
                    distro = $variant['distro']
                    distro_version = $variant['distro_version']
                    platforms = & {
                        if ($variant -in @( '3.3', '3.4', '3.5' ) ) {
                            'linux/amd64'
                        }else {
                            'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/s390x'
                        }
                    }
                    components = $subVariant['components']
                }
                # Docker image tag. E.g. '3.8-curl'
                tag = @(
                        $variant['package_version']
                        $subVariant['components'] | ? { $_ }
                        $variant['distro']
                        $variant['distro_version']
                ) -join '-'
                tag_as_latest = if ( $subVariant.Contains('tag_as_latest') ) {
                                    $subVariant['tag_as_latest']
                                } else {
                                    $false
                                }
            }
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}
