/*
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.cloud.tools.eclipse.appengine.libraries;

import com.google.common.collect.ImmutableList;
import java.util.Iterator;
import javax.xml.namespace.NamespaceContext;

// todo put a real class in utilities somewhere
class Maven4NamespaceContext implements NamespaceContext {

  @Override
  public String getNamespaceURI(String prefix) {
    return "http://maven.apache.org/POM/4.0.0";
  }

  @Override
  public String getPrefix(String namespaceURI) {
    return "m";
  }

  @Override
  public Iterator<String> getPrefixes(String namespaceURI) {
    return ImmutableList.of("m").iterator();
  }

}
