FROM nixos/nix:2.3.10 AS builder

# update packages
RUN nix-channel --update nixpkgs
RUN nix-env -iA cachix -f https://cachix.org/api/v1/install \
      && nix-env -iA nixpkgs.git \
      && cachix use digitallyinduced

WORKDIR /app

# create the nix-shell
RUN git clone --depth 1 --branch v0.9.0 https://github.com/digitallyinduced/ihp.git ./IHP
COPY .gitignore . 
COPY default.nix . 
COPY Config/nix ./Config/nix
RUN nix-shell

# run nix-build
COPY Application ./Application
COPY Config ./Config
COPY Web ./Web
COPY static ./static 
COPY build.nix . 
COPY Setup.hs .
COPY Main.hs . 
COPY Makefile .
RUN nix-build

# Store all runtime dependencies in a folder
RUN mkdir /tmp/nix-store-closure && cp -R $(nix-store -qR result/) /tmp/nix-store-closure 

# run image
FROM gcr.io/distroless/base:nonroot
USER nonroot

WORKDIR /app
COPY --from=builder /tmp/nix-store-closure /nix/store
COPY --from=builder /app/result ./result
COPY --from=builder /app/static ./static
COPY --from=builder /app/IHP ./IHP

ENTRYPOINT ["./result/bin/RunProdServer"]
