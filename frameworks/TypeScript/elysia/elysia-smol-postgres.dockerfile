FROM oven/bun:1.1

EXPOSE 8080

COPY . .

ENV NODE_ENV production

RUN bun install --production

RUN bun run build

ENV DATABASE postgres

RUN sed -i 's/smol = false/smol = true/g' bunfig.toml

CMD ["bun", "spawn.ts"]
