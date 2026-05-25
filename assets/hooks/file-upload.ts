import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { FileUpload } from "../components/file-upload";
import type {
  Props,
  FileChangeDetails,
  FileAcceptDetails,
  FileRejectDetails,
} from "@zag-js/file-upload";
import { getString, getBoolean, getDir, getNumber, canPushEvent } from "../lib/util";
import { bindArrayFieldSubmitIntent } from "../lib/form-array-submit";
import { notifyChange, idMatches, readPayloadId } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type FileUploadHookState = {
  fileUpload?: FileUpload;
  handlers?: Array<CallbackRef>;
  unbindSubmitIntent?: () => void;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
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

const FileUploadHook: Hook<object & FileUploadHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & FileUploadHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
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
    zag.init();
    this.fileUpload = zag;
    this.handlers = [];

    this.unbindSubmitIntent = bindArrayFieldSubmitIntent(el, () => {
      zag.syncFormSubmitInputs();
    });

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add("corex:file-upload:clear-files", () => {
      zag.api.clearFiles();
    });

    domRegistry.add("corex:file-upload:clear-rejected", () => {
      zag.api.clearRejectedFiles();
    });

    domRegistry.add("corex:file-upload:open", () => {
      zag.api.openFilePicker();
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("file_upload_clear_files", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearFiles();
    });

    registry.add("file_upload_clear_rejected", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearRejectedFiles();
    });

    registry.add("file_upload_open", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.openFilePicker();
    });
  },

  updated(this: object & HookInterface<HTMLElement> & FileUploadHookState) {
    this.fileUpload?.updateProps({
      id: this.el.id,
      disabled: getBoolean(this.el, "disabled"),
      invalid: getBoolean(this.el, "invalid"),
      readOnly: getBoolean(this.el, "readonly"),
      required: getBoolean(this.el, "required"),
      name: getString(this.el, "name"),
      dir: getDir(this.el),
      allowDrop:
        this.el.dataset.allowDrop === undefined ? true : this.el.dataset.allowDrop !== "false",
      preventDocumentDrop:
        this.el.dataset.preventDocumentDrop === undefined
          ? true
          : this.el.dataset.preventDocumentDrop !== "false",
      maxFiles: getNumber(this.el, "maxFiles") ?? 1,
      maxFileSize: getNumber(this.el, "maxFileSize") ?? Number.POSITIVE_INFINITY,
      minFileSize: getNumber(this.el, "minFileSize") ?? 0,
      accept: getString(this.el, "accept"),
      directory: getBoolean(this.el, "directory"),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & FileUploadHookState) {
    this.unbindSubmitIntent?.();
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.fileUpload?.cleanupPreviews();
    this.fileUpload?.destroy();
  },
};

export { FileUploadHook as FileUpload };
