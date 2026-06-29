cd apps/web
pnpm install
pnpm build
cd ../..
git add -A
git commit -m "prod deploy"
git push origin main
