


all:
	rm -rf site
	gostatic -f ./conf
	rsync -ar --del site/ root@143.198.76.122:/var/www/html/deadsfu

	rm -rf site
	gostatic -f ./conf1
	rsync -ar --del site/ root@143.198.76.122:/var/www/html/cameronelliott

	scp Caddyfile root@143.198.76.122:/etc/caddy/Caddyfile
	ssh root@143.198.76.122 systemctl reload caddy



# you don't really need to install
# postcss, Cameron!
# nope: npm i -D postcss postcss-cli


watch:
	npx tailwindcss -o tailwind.css --watch

