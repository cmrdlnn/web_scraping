import React, { Component, Fragment } from 'react';

import download from 'downloadjs';
import MomentJS from 'moment';
import 'moment/locale/ru';

import Modal from 'react-modal';

import { objectToParams, request } from '../utils';

import Button from '../components/Button';
import InputMoment from '../components/InputMoment';
import Spinner from '../components/Spinner';

import BNKomiIcon from './icons/bnkomi.png';
import KomiInformIcon from './icons/komiinform.png';

import './css/app.css';

const modalStyles = {
  content: {
    top: '50%',
    left: '50%',
    right: 'auto',
    bottom: 'auto',
    marginRight: '-50%',
    transform: 'translate(-50%, -50%)',
  },
  overlay: {
    backgroundColor: 'rgba(0, 0, 0, 0.75)',
  },
};

class App extends Component {
  constructor(props) {
    super(props);

    const moment = MomentJS().utc();
    moment.endOf('day');
    const finish = this.interval(moment);
    moment.startOf('day');
    const start = this.interval(moment);

    this.state = {
      start,
      finish,
      modalIsOpen: false,
      moment,
      loading: false,
    };
  }

  interval = (moment = this.state.moment) => {
    const readable = moment.format('ll');
    const iso = moment.toISOString();

    return { readable, iso };
  }

  handleChange = (moment) => {
    this.setState({ moment });
  }

  handleSave = (intervalPart) => {
    /*
    const { finish, moment, start } = this.state;

    if (intervalPart === 'start' && moment.isAfter(finish.iso)) {

    } else if (intervalPart === 'finish' && moment.isBefore(start.iso)) {

    }
    */
    this.setState({ [intervalPart]: this.interval() }, this.close);
  }

  startChanging = () => { this.open('start'); }

  finishChanging = () => { this.open('finish'); }

  open = (intervalPart) => {
    this.setState({ onSave: () => { this.handleSave(intervalPart); } }, this.toggle);
  }

  close = () => { this.toggle(false); }

  toggle = (isOpening = !this.state.modalIsOpen) => {
    this.setState({ modalIsOpen: isOpening });
  }

  downloadBNKomi = () => {
    this.download('bnk');
  }

  downloadBNKomiStat = () => {
    this.download('bnk', 'stat');
  }

  downloadKomiInform = () => {
    this.download('komiinform');
  }

  download = (site, path = 'comments') => {
    const { start: { iso: start }, finish: { iso: finish } } = this.state;
    const url = `api/${site}/${path}${objectToParams({ start, finish })}`;

    this.setState({ loading: true });

    return request(url)
      .then((response) => {
        const contentDisposition = response.headers.get('Content-Disposition');
        const filename = contentDisposition.match(/filename="(.+)"/)[1];

        response.blob()
          .then((file) => {
            download(file, filename, file.type);
            this.setState({ loading: false });
          });
      });
  }

  render() {
    const { finish, loading, modalIsOpen, moment, onSave, start } = this.state;

    if (loading) return <Spinner />;

    return (
      <Fragment>
        <div className="interval line">
          <button
            className="btn"
            onClick={this.startChanging}
            type="button"
          >
            Изменить начальную дату
          </button>
          { start.readable }
          {' - '}
          { finish.readable }
          <button
            className="btn"
            onClick={this.finishChanging}
            type="button"
          >
            Изменить конечную дату
          </button>
        </div>
        <div className="line">
          <Button
            assign="left"
            icon={BNKomiIcon}
            onClick={this.downloadBNKomi}
            title="Комментарии БНК"
            view="slant-left"
          />
          <Button
            assign="right"
            icon={KomiInformIcon}
            onClick={this.downloadKomiInform}
            title="Комментарии Комиинформ"
            view="slant-left"
          />
        </div>
        <div className="line">
          <Button
            assign="left"
            icon={BNKomiIcon}
            onClick={this.downloadBNKomiStat}
            title="Статистика БНК"
            view="slant-right"
          />
        </div>
        <Modal
          ariaHideApp={false}
          contentLabel="InputMoment"
          isOpen={modalIsOpen}
          onRequestClose={this.close}
          style={modalStyles}
        >
          <InputMoment
            moment={moment}
            onChange={this.handleChange}
            onSave={onSave}
          />
        </Modal>
      </Fragment>
    );
  }
}

export default App;
