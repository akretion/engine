import React from 'react';
import { Redirect } from 'react-router-dom';
import { bindAll, compact } from 'lodash';

export default function withRoutes(Component) {

  const buildRoutes = (pageId, contentEntryId) => {
    const _pageId   = compact([pageId, contentEntryId]).join('-');
    const basePath  = `/${_pageId}/content/edit`;

    const sectionsPath          = () => `${basePath}/sections`;
    const newSectionPath        = () => `${basePath}/dropzone_sections/pick`;

    const staticSectionPath   = sectionType => `${sectionsPath()}/${sectionType}`;
    const dropzoneSectionPath = (sectionType, sectionId) => {
      return `${basePath}/dropzone_sections/${sectionType}/${sectionId}`;
    }

    const sectionPath = (sectionType, sectionId) => {
      return sectionId ? dropzoneSectionPath(sectionType, sectionId) : staticSectionPath(sectionType);
    }
    const editSectionPath = (sectionType, sectionId) => {
      return `${sectionPath(sectionType, sectionId)}/edit`;
    }

    const blockPath = (sectionType, sectionId, blockType, blockId) => {
      return `${sectionPath(sectionType, sectionId)}/blocks/${blockType}/${blockId}`;
    }
    const editBlockPath = (sectionType, sectionId, blockType, blockId) => {
      return `${blockPath(sectionType, sectionId, blockType, blockId)}/edit`;
    }

    const blockParentPath = (sectionType, sectionId) => {
      return `${sectionPath(sectionType, sectionId)}/edit`;
    }

    const imagesPath = (sectionType, sectionId, blockType, blockId, settingType, settingId) => {
      const postfix = `setting/${settingType}/${settingId}/images`;

      if (blockType && blockId)
        return `${blockPath(sectionType, sectionId, blockType, blockId)}/${postfix}`;
      else
        return `${sectionPath(sectionType, sectionId)}/${postfix}`;
    }

    return {
      sectionsPath,
      editSectionPath,
      newSectionPath,
      editBlockPath,
      blockParentPath,
      imagesPath
    }
  }

  return class WrappedComponent extends React.Component {

    constructor(props) {
      super(props);
      this.state = {};
      bindAll(this, 'redirectTo');
    }

    redirectTo(pathname) {
      this.setState({ redirectTo: pathname })
    }

    render() {
      return this.state.redirectTo === undefined ? (
        <Component
          redirectTo={this.redirectTo}
          {...buildRoutes(this.props.pageId, this.props.contentEntryId)}
          {...this.props}
        />
      ) : (
        <Redirect to={{ pathname: this.state.redirectTo }} />
      );
    }

  }

}
