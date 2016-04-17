/*
 * Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.wso2.carbon.gateway.core.config;

import org.wso2.carbon.gateway.core.inbound.InboundEndpoint;

/**
 * represents a group
 */
public class Group {
    private String path;
    private String name;
    private String method;
    private String scheme;

    private InboundEndpoint inboundEndpoint;

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getScheme() {
        return scheme;
    }

    public void setScheme(String scheme) {
        this.scheme = scheme;
    }

    public InboundEndpoint getInboundEndpoint() {
        return inboundEndpoint;
    }

    public void setInboundEndpoint(InboundEndpoint inboundEndpoint) {
        this.inboundEndpoint = inboundEndpoint;
    }

    public Group(String path) {
        this.path = path;
    }
}
