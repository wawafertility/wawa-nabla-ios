// @generated
// This file was automatically generated and should not be edited.

import Apollo

extension GQL {
  struct SendVideoMessageInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      upload: UploadInput
    ) {
      __data = InputDict([
        "upload": upload
      ])
    }

    var upload: UploadInput {
      get { __data["upload"] }
      set { __data["upload"] = newValue }
    }
  }

}