package util

import (
	"strings"

	"crypto/ed25519"
	"encoding/hex"
	com "github.com/aureontu/MRWebServer/mr_services/common"
)

func ReadNonceFromAptosFullMsg(msg string) string {
	for _, v := range strings.Split(msg, "\n") {
		if strings.HasPrefix(v, "nonce:") {
			nonce := v[7:]
			for len(nonce) < com.NonceLen {
				nonce = "0" + nonce
			}
			return nonce
		}
	}
	return ""
}

func EncodeAptosPubKey(pubKey []byte) string {
	return "0x" + hex.EncodeToString(pubKey)
}

func DecodeAptosPubKey(pubKeyHex string) ([]byte, error) {
	if pubKeyHex[:2] == "0x" {
		pubKeyHex = pubKeyHex[2:]
	}
	pubKey, err := hex.DecodeString(pubKeyHex)
	if err != nil {
		return nil, err
	}
	return pubKey, nil
}

func VerifySignature(publicKey []byte, msg string, signatureHex string) bool {
	if signatureHex[:2] == "0x" {
		signatureHex = signatureHex[:2]
	}
	var signature = make([]byte, 64)
	n, err := hex.Decode(signature, []byte(signatureHex))
	if err != nil {
		return false
	}
	return ed25519.Verify(publicKey, []byte(msg), signature[:n])
}
