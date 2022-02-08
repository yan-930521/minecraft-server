{ pkgs }: {
	deps = [
        pkgs.jre_minimal
        pkgs.wget
        pkgs.unzip
        pkgs.jq
        pkgs.nodejs
	];
}