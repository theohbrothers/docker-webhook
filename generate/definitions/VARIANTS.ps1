# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    @{
        package = 'webhook'
        package_version = '2.8.1'
        distro = 'alpine'
        distro_version = '3.17'
        subvariants = @(
            @{ components = @() }
            @{ components = @( 'libvirt-8' ) }
            @{ components = @( 'curl', 'git', 'jq', 'sops', 'ssh' ) }
        )
    }
    @{
        package = 'webhook'
        package_version = '2.8.1'
        distro = 'alpine'
        distro_version = '3.15'
        subvariants = @(
            @{ components = @() }
            @{ components = @( 'libvirt-7' ) }
            @{ components = @( 'curl', 'git', 'jq', 'sops', 'ssh' ) }
        )
    }
    @{
        package = 'webhook'
        package_version = '2.8.1'
        distro = 'alpine'
        distro_version = '3.13'
        subvariants = @(
            @{ components = @() }
            @{ components = @( 'libvirt-6' ) }
            @{ components = @( 'curl', 'git', 'jq', 'sops', 'ssh' ) }
        )
    }
    @{
        package = 'webhook'
        package_version = '2.7.0'
        distro = 'alpine'
        distro_version = '3.13'
        subvariants = @(
            @{ components = @() }
            @{ components = @( 'curl', 'git', 'jq', 'sops', 'ssh' ) }
        )
    }
    @{
        package = 'webhook'
        package_version = '2.8.1'
        distro = 'alpine'
        distro_version = '3.12'
        subvariants = @(
            @{ components = @() }
            @{ components = @( 'curl', 'git', 'jq', 'sops', 'ssh' ) }
        )
    }
    @{
        package = 'webhook'
        package_version = '2.7.0'
        distro = 'alpine'
        distro_version = '3.12'

        subvariants = @(
            @{ components = @() }
            @{ components = @( 'curl', 'git', 'jq', 'sops', 'ssh' ) }
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
                            'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64'
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
                tag_as_latest = if ($variant['package_version'] -eq $local:VARIANTS_MATRIX[0]['package_version'] -and $variant['distro_version'] -eq $local:VARIANTS_MATRIX[0]['distro_version']  -and $subVariant['components'].Count -eq 0) { $true } else { $false }
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
