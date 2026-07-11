FROM node:22-alpine
WORKDIR /app
COPY apps/capsule-studio/package.json ./package.json
COPY apps/capsule-studio/server.js ./server.js
COPY apps/capsule-studio/public ./public
COPY apps/capsule-studio/scripts ./scripts
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=8787
EXPOSE 8787
CMD ["node", "server.js"]
