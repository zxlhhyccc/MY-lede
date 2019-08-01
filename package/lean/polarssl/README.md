# PolarSSL for shadowsocks-libev

At OpenWRT SDK root or build root:

```
pushd package
git clone https://github.com/Blaok/polarssl-for-sslibev.git lib/polarssl
git clone https://github.com/Blaok/mbedtls-for-sslibev.git lib/mbedtls
git clone https://github.com/shadowsocks/shadowsocks-libev.git
popd
scripts/feeds install -d m shadowsocks-libev
make package/shadowsocks-libev/openwrt/compile
```

Package should appear at `bin/${arch}/packages/base`.
