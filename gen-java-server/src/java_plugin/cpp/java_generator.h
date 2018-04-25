/*
 * Copyright 2018 Nordstrom, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * NOTICE: Modified from gRPC-java java_generator.h found at:
 * https://github.com/grpc/grpc-java/blob/master/compiler/src/java_plugin/cpp/java_generator.h
 */

#ifndef NET_GRPC_COMPILER_JAVA_GENERATOR_H_
#define NET_GRPC_COMPILER_JAVA_GENERATOR_H_

#include <stdlib.h>  // for abort()
#include <iostream>
#include <string>

#include <google/protobuf/io/zero_copy_stream.h>
#include <google/protobuf/descriptor.h>

using namespace std;

namespace java_xrpc_generator {

// Returns the package name of the gRPC services defined in the given file.
string ServiceJavaPackage(const google::protobuf::FileDescriptor *file);

// Returns the name of the outer class that wraps in all the generated code for
// the given service.
string ServiceClassName(const google::protobuf::ServiceDescriptor *service);

// Writes the generated service interface into the given ZeroCopyOutputStream
void GenerateService(const google::protobuf::ServiceDescriptor *service,
                     google::protobuf::io::ZeroCopyOutputStream *out);

}  // namespace java_grpc_generator

#endif  // NET_GRPC_COMPILER_JAVA_GENERATOR_H_
