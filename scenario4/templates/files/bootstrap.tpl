<?xml version="1.0"?>
<config version="11.0.0" urldb="paloaltonetworks" detail-version="11.0.2">
  <mgt-config>
    <users>
      <entry name="admin">
        <phash>*</phash>
        <permissions>
          <role-based>
            <superuser>yes</superuser>
          </role-based>
        </permissions>
      </entry>
      <entry name="panadmin">
        <phash>$5$oftmcqpp$LjvO/RDyvFtv.42RVo8TXNoP9Rj9toF.UF7RtuK.yV7</phash>
        <permissions>
          <role-based>
            <superuser>yes</superuser>
          </role-based>
        </permissions>
      </entry>
    </users>
    <password-complexity>
      <enabled>yes</enabled>
      <minimum-length>8</minimum-length>
    </password-complexity>
  </mgt-config>
  <shared>
    <application/>
    <application-group/>
    <service/>
    <service-group/>
    <botnet>
      <configuration>
        <http>
          <dynamic-dns>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </dynamic-dns>
          <malware-sites>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </malware-sites>
          <recent-domains>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </recent-domains>
          <ip-domains>
            <enabled>yes</enabled>
            <threshold>10</threshold>
          </ip-domains>
          <executables-from-unknown-sites>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </executables-from-unknown-sites>
        </http>
        <other-applications>
          <irc>yes</irc>
        </other-applications>
        <unknown-applications>
          <unknown-tcp>
            <destinations-per-hour>10</destinations-per-hour>
            <sessions-per-hour>10</sessions-per-hour>
            <session-length>
              <maximum-bytes>100</maximum-bytes>
              <minimum-bytes>50</minimum-bytes>
            </session-length>
          </unknown-tcp>
          <unknown-udp>
            <destinations-per-hour>10</destinations-per-hour>
            <sessions-per-hour>10</sessions-per-hour>
            <session-length>
              <maximum-bytes>100</maximum-bytes>
              <minimum-bytes>50</minimum-bytes>
            </session-length>
          </unknown-udp>
        </unknown-applications>
      </configuration>
      <report>
        <topn>100</topn>
        <scheduled>yes</scheduled>
      </report>
    </botnet>
  </shared>
  <devices>
    <entry name="localhost.localdomain">
      <network>
        <interface>
          <ethernet>
            <entry name="ethernet1/1">
              <layer3>
                <ndp-proxy>
                  <enabled>no</enabled>
                </ndp-proxy>
                <sdwan-link-settings>
                  <upstream-nat>
                    <enable>no</enable>
                    <static-ip/>
                  </upstream-nat>
                  <enable>no</enable>
                </sdwan-link-settings>
                <lldp>
                  <enable>no</enable>
                </lldp>
                <dhcp-client/>
                <interface-management-profile>MP-Trust</interface-management-profile>
              </layer3>
            </entry>
            <entry name="ethernet1/2">
              <layer3>
                <ndp-proxy>
                  <enabled>no</enabled>
                </ndp-proxy>
                <sdwan-link-settings>
                  <upstream-nat>
                    <enable>no</enable>
                    <static-ip/>
                  </upstream-nat>
                  <enable>no</enable>
                </sdwan-link-settings>
                <lldp>
                  <enable>no</enable>
                </lldp>
                <dhcp-client/>
                <interface-management-profile>MP-Untrust</interface-management-profile>
              </layer3>
            </entry>
          </ethernet>
        </interface>
        <profiles>
          <monitor-profile>
            <entry name="default">
              <interval>3</interval>
              <threshold>5</threshold>
              <action>wait-recover</action>
            </entry>
          </monitor-profile>
          <interface-management-profile>
            <entry name="MP-Trust">
              <permitted-ip>
                <entry name="168.63.129.16/32"/>
              </permitted-ip>
              <https>yes</https>
            </entry>
            <entry name="MP-Untrust">
              <permitted-ip>
                <entry name="168.63.129.16/32"/>
              </permitted-ip>
              <ssh>yes</ssh>
            </entry>
          </interface-management-profile>
        </profiles>
        <ike>
          <crypto-profiles>
            <ike-crypto-profiles>
              <entry name="default">
                <encryption>
                  <member>aes-128-cbc</member>
                  <member>3des</member>
                </encryption>
                <hash>
                  <member>sha1</member>
                </hash>
                <dh-group>
                  <member>group2</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-128">
                <encryption>
                  <member>aes-128-cbc</member>
                </encryption>
                <hash>
                  <member>sha256</member>
                </hash>
                <dh-group>
                  <member>group19</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-256">
                <encryption>
                  <member>aes-256-cbc</member>
                </encryption>
                <hash>
                  <member>sha384</member>
                </hash>
                <dh-group>
                  <member>group20</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
            </ike-crypto-profiles>
            <ipsec-crypto-profiles>
              <entry name="default">
                <esp>
                  <encryption>
                    <member>aes-128-cbc</member>
                    <member>3des</member>
                  </encryption>
                  <authentication>
                    <member>sha1</member>
                  </authentication>
                </esp>
                <dh-group>group2</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-128">
                <esp>
                  <encryption>
                    <member>aes-128-gcm</member>
                  </encryption>
                  <authentication>
                    <member>none</member>
                  </authentication>
                </esp>
                <dh-group>group19</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-256">
                <esp>
                  <encryption>
                    <member>aes-256-gcm</member>
                  </encryption>
                  <authentication>
                    <member>none</member>
                  </authentication>
                </esp>
                <dh-group>group20</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
            </ipsec-crypto-profiles>
            <global-protect-app-crypto-profiles>
              <entry name="default">
                <encryption>
                  <member>aes-128-cbc</member>
                </encryption>
                <authentication>
                  <member>sha1</member>
                </authentication>
              </entry>
            </global-protect-app-crypto-profiles>
          </crypto-profiles>
        </ike>
        <qos>
          <profile>
            <entry name="default">
              <class-bandwidth-type>
                <mbps>
                  <class>
                    <entry name="class1">
                      <priority>real-time</priority>
                    </entry>
                    <entry name="class2">
                      <priority>high</priority>
                    </entry>
                    <entry name="class3">
                      <priority>high</priority>
                    </entry>
                    <entry name="class4">
                      <priority>medium</priority>
                    </entry>
                    <entry name="class5">
                      <priority>medium</priority>
                    </entry>
                    <entry name="class6">
                      <priority>low</priority>
                    </entry>
                    <entry name="class7">
                      <priority>low</priority>
                    </entry>
                    <entry name="class8">
                      <priority>low</priority>
                    </entry>
                  </class>
                </mbps>
              </class-bandwidth-type>
            </entry>
          </profile>
        </qos>
        <virtual-router>
          <entry name="VR-Trust">
            <ecmp>
              <algorithm>
                <ip-modulo/>
              </algorithm>
            </ecmp>
            <protocol>
              <bgp>
                <routing-options>
                  <graceful-restart>
                    <enable>yes</enable>
                  </graceful-restart>
                </routing-options>
                <enable>no</enable>
              </bgp>
              <rip>
                <enable>no</enable>
              </rip>
              <ospf>
                <enable>no</enable>
              </ospf>
              <ospfv3>
                <enable>no</enable>
              </ospfv3>
            </protocol>
            <routing-table>
              <ip>
                <static-route>
                  <entry name="Private">
                    <nexthop>
                      <ip-address>${next-hop-trusted}</ip-address>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <interface>ethernet1/1</interface>
                    <metric>10</metric>
                    <destination>10.0.0.0/8</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                  <entry name="Default">
                    <nexthop>
                      <next-vr>VR-Untrust</next-vr>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <metric>10</metric>
                    <destination>0.0.0.0/0</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                  <entry name="Azure_LB_Probe">
                    <nexthop>
                      <ip-address>${next-hop-trusted}</ip-address>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <interface>ethernet1/1</interface>
                    <metric>10</metric>
                    <destination>168.63.129.16/32</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                </static-route>
              </ip>
            </routing-table>
            <interface>
              <member>ethernet1/1</member>
            </interface>
          </entry>
          <entry name="VR-Untrust">
            <ecmp>
              <algorithm>
                <ip-modulo/>
              </algorithm>
            </ecmp>
            <protocol>
              <bgp>
                <routing-options>
                  <graceful-restart>
                    <enable>yes</enable>
                  </graceful-restart>
                </routing-options>
                <enable>no</enable>
              </bgp>
              <rip>
                <enable>no</enable>
              </rip>
              <ospf>
                <enable>no</enable>
              </ospf>
              <ospfv3>
                <enable>no</enable>
              </ospfv3>
            </protocol>
            <interface>
              <member>ethernet1/2</member>
            </interface>
            <routing-table>
              <ip>
                <static-route>
                  <entry name="Default">
                    <nexthop>
                      <ip-address>${next-hop-untrusted}</ip-address>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <interface>ethernet1/2</interface>
                    <metric>10</metric>
                    <destination>0.0.0.0/0</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                  <entry name="Trust">
                    <nexthop>
                      <next-vr>VR-Trust</next-vr>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <metric>10</metric>
                    <destination>10.0.0.0/8</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                  <entry name="Azure_LB_Probe">
                    <nexthop>
                      <ip-address>${next-hop-untrusted}</ip-address>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <interface>ethernet1/2</interface>
                    <metric>10</metric>
                    <destination>168.63.129.16/32</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                </static-route>
              </ip>
            </routing-table>
          </entry>
        </virtual-router>
      </network>
      <deviceconfig>
        <system>
          <type>
            <dhcp-client>
              <send-hostname>yes</send-hostname>
              <send-client-id>no</send-client-id>
              <accept-dhcp-hostname>no</accept-dhcp-hostname>
              <accept-dhcp-domain>no</accept-dhcp-domain>
            </dhcp-client>
          </type>
          <update-server>updates.paloaltonetworks.com</update-server>
          <update-schedule>
            <threats>
              <recurring>
                <weekly>
                  <day-of-week>wednesday</day-of-week>
                  <at>01:02</at>
                  <action>download-only</action>
                </weekly>
              </recurring>
            </threats>
          </update-schedule>
          <timezone>Europe/Paris</timezone>
          <service>
            <disable-telnet>yes</disable-telnet>
            <disable-http>yes</disable-http>
          </service>
          <hostname>panfw-vm</hostname>
          <ntp-servers>
            <primary-ntp-server>
              <ntp-server-address>time.windows.com</ntp-server-address>
              <authentication-type>
                <none/>
              </authentication-type>
            </primary-ntp-server>
            <secondary-ntp-server>
              <ntp-server-address>time.google.com</ntp-server-address>
              <authentication-type>
                <none/>
              </authentication-type>
            </secondary-ntp-server>
          </ntp-servers>
        </system>
        <setting>
          <config>
            <rematch>yes</rematch>
          </config>
          <management>
            <hostname-type-in-syslog>FQDN</hostname-type-in-syslog>
            <initcfg>
              <hostname>panfw-vm</hostname>
              <username>panadmin</username>
              <type>
                <dhcp-client>
                  <send-hostname>yes</send-hostname>
                  <send-client-id>no</send-client-id>
                  <accept-dhcp-hostname>no</accept-dhcp-hostname>
                  <accept-dhcp-domain>no</accept-dhcp-domain>
                </dhcp-client>
              </type>
            </initcfg>
          </management>
        </setting>
      </deviceconfig>
      <vsys>
        <entry name="vsys1">
          <application/>
          <application-group/>
          <zone>
            <entry name="trust">
              <network>
                <layer3>
                  <member>ethernet1/1</member>
                </layer3>
              </network>
            </entry>
            <entry name="untrust">
              <network>
                <layer3>
                  <member>ethernet1/2</member>
                </layer3>
              </network>
            </entry>
          </zone>
          <service>
            <entry name="SSH">
              <protocol>
                <tcp>
                  <port>22</port>
                  <override>
                    <no/>
                  </override>
                </tcp>
              </protocol>
            </entry>
          </service>
          <service-group/>
          <schedule/>
          <rulebase>
            <security>
              <rules>
                <entry name="A-TRUSTED-TRUSTED-ALL" uuid="de53e0ef-e1f5-4e53-b1a4-7da08eee26ee">
                  <to>
                    <member>trust</member>
                  </to>
                  <from>
                    <member>trust</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <source-user>
                    <member>any</member>
                  </source-user>
                  <category>
                    <member>any</member>
                  </category>
                  <application>
                    <member>any</member>
                  </application>
                  <service>
                    <member>any</member>
                  </service>
                  <source-hip>
                    <member>any</member>
                  </source-hip>
                  <destination-hip>
                    <member>any</member>
                  </destination-hip>
                  <action>allow</action>
                </entry>
                <entry name="A-TRUST-TRUST-PING" uuid="f1c46d56-f566-411a-8790-9219f93703e2">
                  <to>
                    <member>trust</member>
                  </to>
                  <from>
                    <member>trust</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <source-user>
                    <member>any</member>
                  </source-user>
                  <category>
                    <member>any</member>
                  </category>
                  <application>
                    <member>ping</member>
                  </application>
                  <service>
                    <member>application-default</member>
                  </service>
                  <source-hip>
                    <member>any</member>
                  </source-hip>
                  <destination-hip>
                    <member>any</member>
                  </destination-hip>
                  <action>allow</action>
                  <log-start>yes</log-start>
                </entry>
                <entry name="A-TRUST-UNTRUST-HTTP_HTTPS" uuid="2fd22f44-6e87-415c-8d42-9d0ffd0360ef">
                  <to>
                    <member>untrust</member>
                  </to>
                  <from>
                    <member>trust</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <source-user>
                    <member>any</member>
                  </source-user>
                  <category>
                    <member>any</member>
                  </category>
                  <application>
                    <member>any</member>
                  </application>
                  <service>
                    <member>service-http</member>
                    <member>service-https</member>
                  </service>
                  <source-hip>
                    <member>any</member>
                  </source-hip>
                  <destination-hip>
                    <member>any</member>
                  </destination-hip>
                  <action>allow</action>
                  <log-start>yes</log-start>
                </entry>
                <entry name="AZ_LB_Probe" uuid="a58af74d-01a6-4fea-b2f6-521db69ba411">
                  <to>
                    <member>any</member>
                  </to>
                  <from>
                    <member>any</member>
                  </from>
                  <source>
                    <member>168.63.129.16</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <source-user>
                    <member>any</member>
                  </source-user>
                  <category>
                    <member>any</member>
                  </category>
                  <application>
                    <member>any</member>
                  </application>
                  <service>
                    <member>service-https</member>
                    <member>SSH</member>
                  </service>
                  <source-hip>
                    <member>any</member>
                  </source-hip>
                  <destination-hip>
                    <member>any</member>
                  </destination-hip>
                  <action>allow</action>
                </entry>
                <entry name="DenyAll" uuid="c74e0feb-1c4a-40d2-b374-aabd7414ea13">
                  <to>
                    <member>any</member>
                  </to>
                  <from>
                    <member>any</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <source-user>
                    <member>any</member>
                  </source-user>
                  <category>
                    <member>any</member>
                  </category>
                  <application>
                    <member>any</member>
                  </application>
                  <service>
                    <member>application-default</member>
                  </service>
                  <source-hip>
                    <member>any</member>
                  </source-hip>
                  <destination-hip>
                    <member>any</member>
                  </destination-hip>
                  <action>deny</action>
                  <log-start>yes</log-start>
                </entry>
              </rules>
            </security>
            <nat>
              <rules>
                <entry name="NAT-INTERNET-OUT" uuid="4e8866d8-0059-46fd-892b-185e62d959b5">
                  <source-translation>
                    <dynamic-ip-and-port>
                      <interface-address>
                        <interface>ethernet1/2</interface>
                      </interface-address>
                    </dynamic-ip-and-port>
                  </source-translation>
                  <to>
                    <member>untrust</member>
                  </to>
                  <from>
                    <member>trust</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <service>any</service>
                  <to-interface>ethernet1/2</to-interface>
                </entry>
                <entry name="AZ_LB_Probe_Untrust" uuid="f8aadef0-e4d1-48dd-b9db-a71b7a1e7be7">
                  <to>
                    <member>untrust</member>
                  </to>
                  <from>
                    <member>untrust</member>
                  </from>
                  <source>
                    <member>168.63.129.16/32</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <service>SSH</service>
                  <to-interface>ethernet1/2</to-interface>
                </entry>
                <entry name="AZ_LB_Probe_Trust" uuid="9a687207-211b-4d6f-bbc2-3e2c04ca287d">
                  <to>
                    <member>trust</member>
                  </to>
                  <from>
                    <member>trust</member>
                  </from>
                  <source>
                    <member>168.63.129.16/32</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <service>service-https</service>
                  <to-interface>ethernet1/1</to-interface>
                </entry>
              </rules>
            </nat>
          </rulebase>
          <import>
            <network>
              <interface>
                <member>ethernet1/1</member>
                <member>ethernet1/2</member>
              </interface>
            </network>
          </import>
        </entry>
      </vsys>
    </entry>
  </devices>
</config>
