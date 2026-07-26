import { FileUpload } from "../components/file-upload";
import type {
  Props,
  FileChangeDetails,
  FileAcceptDetails,
  FileRejectDetails,
} from "@zag-js/file-upload";
import { getString, getBoolean, getDir, getNumber, canPushEvent } from "../lib/util";
import { bindArrayFieldSubmitIntent } from "../lib/phoenix-form-bridge";
import { notifyChange, idMatches, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type FileUploadHookState = {
  fileUpload?: FileUpload;
  unbindSubmitIntent?: () => void;
};

export function fileChangePayload(
  el: HTMLElement,
  details: FileChangeDetails
): Record<string, unknown> {
  const first = details.acceptedFiles[0];
  return {
    id: el.id,
    acceptedCount: details.acceptedFiles.length,
    rejectedCount: details.rejectedFiles.length,
    acceptedNames: details.acceptedFiles.map((file) => file.name),
    firstAcceptedName: first?.name ?? null,
    firstAcceptedType: first?.type ?? null,
  };
}

export function fileAcceptPayload(
  el: HTMLElement,
  details: FileAcceptDetails
): Record<string, unknown> {
  return {
    id: el.id,
    count: details.files.length,
  };
}

export function fileRejectPayload(
  el: HTMLElement,
  details: FileRejectDetails
): Record<string, unknown> {
  return {
    id: el.id,
    count: details.files.length,
  };
}

const FileUploadHook = createZagLiveHook<FileUploadHookState, FileUpload>({
  key: "fileUpload",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const maxFiles = getNumber(el, "maxFiles");
    const maxFileSize = getNumber(el, "maxFileSize");
    const minFileSize = getNumber(el, "minFileSize");
    const allowDropRaw = el.dataset.allowDrop;
    const preventDropRaw = el.dataset.preventDocumentDrop;
    const dropzoneI18n = getString(el, "translationDropzone");

    const zag = new FileUpload(el, {
      id: el.id,
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      name: getString(el, "name"),
      dir: getDir(el),
      allowDrop: allowDropRaw === undefined ? true : allowDropRaw !== "false",
      preventDocumentDrop: preventDropRaw === undefined ? true : preventDropRaw !== "false",
      maxFiles: maxFiles ?? 1,
      maxFileSize: maxFileSize ?? Number.POSITIVE_INFINITY,
      minFileSize: minFileSize ?? 0,
      accept: getString(el, "accept"),
      directory: getBoolean(el, "directory"),
      translations: dropzoneI18n ? { dropzone: dropzoneI18n } : undefined,
      onFileChange: (details: FileChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: fileChangePayload(el, details),
          serverEventName: getString(el, "onFileChange"),
          clientEventName: getString(el, "onFileChangeClient"),
        });
      },
      onFileAccept: (details: FileAcceptDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: fileAcceptPayload(el, details),
          serverEventName: getString(el, "onFileAccept"),
          clientEventName: getString(el, "onFileAcceptClient"),
        });
      },
      onFileReject: (details: FileRejectDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: fileRejectPayload(el, details),
          serverEventName: getString(el, "onFileReject"),
          clientEventName: getString(el, "onFileRejectClient"),
        });
      },
    } as Props);

    hook.unbindSubmitIntent = bindArrayFieldSubmitIntent(el, () => {
      zag.syncFormSubmitInputs();
    });

    dom.add("corex:file-upload:clear-files", () => {
      zag.api.clearFiles();
    });

    dom.add("corex:file-upload:clear-rejected", () => {
      zag.api.clearRejectedFiles();
    });

    dom.add("corex:file-upload:open", () => {
      zag.api.openFilePicker();
    });

    server.add("file_upload_clear_files", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearFiles();
    });

    server.add("file_upload_clear_rejected", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearRejectedFiles();
    });

    server.add("file_upload_open", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.openFilePicker();
    });

    return zag;
  },

  update(hook, zag) {
    zag.updateProps({
      id: hook.el.id,
      disabled: getBoolean(hook.el, "disabled"),
      invalid: getBoolean(hook.el, "invalid"),
      readOnly: getBoolean(hook.el, "readonly"),
      required: getBoolean(hook.el, "required"),
      name: getString(hook.el, "name"),
      dir: getDir(hook.el),
      allowDrop:
        hook.el.dataset.allowDrop === undefined ? true : hook.el.dataset.allowDrop !== "false",
      preventDocumentDrop:
        hook.el.dataset.preventDocumentDrop === undefined
          ? true
          : hook.el.dataset.preventDocumentDrop !== "false",
      maxFiles: getNumber(hook.el, "maxFiles") ?? 1,
      maxFileSize: getNumber(hook.el, "maxFileSize") ?? Number.POSITIVE_INFINITY,
      minFileSize: getNumber(hook.el, "minFileSize") ?? 0,
      accept: getString(hook.el, "accept"),
      directory: getBoolean(hook.el, "directory"),
    } as Partial<Props>);
  },

  destroy(hook, zag) {
    hook.unbindSubmitIntent?.();
    zag.cleanupPreviews();
  },
});

export { FileUploadHook as FileUpload };
