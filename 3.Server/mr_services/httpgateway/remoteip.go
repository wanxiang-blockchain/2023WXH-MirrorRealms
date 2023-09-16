package httpgateway

import (
	"bytes"
	"net"
	"net/http"
	"strings"
)

// ipRange - a structure that holds the start and end of a range of ip addresses
type ipRange struct {
	start net.IP
	end   net.IP
}

var privateRanges = []ipRange{
	{
		start: net.ParseIP("10.0.0.0"),
		end:   net.ParseIP("10.255.255.255"),
	},
	{
		start: net.ParseIP("100.64.0.0"),
		end:   net.ParseIP("100.127.255.255"),
	},
	{
		start: net.ParseIP("172.16.0.0"),
		end:   net.ParseIP("172.31.255.255"),
	},
	{
		start: net.ParseIP("192.0.0.0"),
		end:   net.ParseIP("192.0.0.255"),
	},
	{
		start: net.ParseIP("192.168.0.0"),
		end:   net.ParseIP("192.168.255.255"),
	},
	{
		start: net.ParseIP("198.18.0.0"),
		end:   net.ParseIP("198.19.255.255"),
	},
}

// isPrivateSubnet - check to see if this ip is in a private subnet
func isPrivateSubnet(ipAddress net.IP) bool {
	// my use case is only concerned with ipv4 atm
	if ipCheck := ipAddress.To4(); ipCheck != nil {
		// iterate over all our ranges
		for _, r := range privateRanges {
			// check if this ip is in a private range
			if inRange(r, ipAddress) {
				return true
			}
		}
	}
	return false
}

// inRange - check to see if a given ip address is within a range given
func inRange(r ipRange, ipAddress net.IP) bool {
	// strcmp type byte comparison
	if bytes.Compare(ipAddress, r.start) >= 0 && bytes.Compare(ipAddress, r.end) < 0 {
		return true
	}
	return false
}

func getRemoteIPAddress(r *http.Request) string {
	for _, hKey := range []string{"X-Forwarded-For", "X-Real-Ip"} { //HAProxy will set real ip into X-Forwarded-For by default in http mode
		if v := r.Header.Get(hKey); v != "" {
			addresses := strings.Split(v, ",")
			// march from right to left until we get a public address
			// that will be the address right before our proxy.
			for i := len(addresses) - 1; i >= 0; i-- {
				ip := strings.TrimSpace(addresses[i])
				// header can contain spaces too, strip those out.
				realIP := net.ParseIP(ip)
				if !realIP.IsGlobalUnicast() || isPrivateSubnet(realIP) {
					// bad address, go to next
					continue
				}
				return ip
			}
		}
	}
	remoteAddr := strings.Split(r.RemoteAddr, ":")
	if len(remoteAddr) != 0 {
		realIP := net.ParseIP(remoteAddr[0])
		if !isPrivateSubnet(realIP) {
			return remoteAddr[0]
		}
	}
	return ""
}

func getRegionByIP(ip string) string { // TODO 考虑使用 maxminddb
	_ = ip
	return "CN"
}
